import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/features/auth/data/auth_repository.dart';
import 'package:plant_app/features/market/domain/entities.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'market_repository.dart';
part 'appwrite_market_repository.g.dart';

class AppwriteMarketRepository implements IMarketplaceService {
  final Databases _databases;
  final String _databaseId;
  final String userId;
  // Collection IDs
  static const String _productsCollection = 'products';
  static const String _ordersCollection = 'orders';
  static const String _orderItemsCollection = 'order_items';
  static const String _cartItemsCollection = 'cart_items';

  AppwriteMarketRepository({
    required Databases databases,
    required String databaseId,
    required this.userId,
  }) : _databases = databases,
       _databaseId = databaseId;

  @override
  Future<List<Product>> getProducts() async {
    final response = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _productsCollection,
    );

    return response.documents.map((doc) => Product.fromDoc(doc)).toList();
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    final response = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _productsCollection,
      queries: [Query.equal('category', category)],
    );

    return response.documents.map((doc) => Product.fromDoc(doc)).toList();
  }

  @override
  Future<Product> getProduct(String productId) async {
    final response = await _databases.getDocument(
      databaseId: _databaseId,
      collectionId: _productsCollection,
      documentId: productId,
    );

    return Product.fromDoc(response);
  }

  @override
  Future<List<CartItem>> getCart() async {
    final response = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _cartItemsCollection,
      queries: [Query.equal('userId', userId)],
    );

    return response.documents.map((doc) => CartItem.fromDoc(doc)).toList();
  }

  @override
  Future<void> addToCart(Product product, int quantity) async {
    // Check if product already in cart
    final existing = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _cartItemsCollection,
      queries: [Query.equal('userId', userId), Query.equal('productId', product.id)],
    );

    if (existing.documents.isNotEmpty) {
      // Update quantity if item exists
      final existingItem = CartItem.fromDoc(existing.documents.first);
      await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _cartItemsCollection,
        documentId: existingItem.id,
        data: {'quantity': existingItem.quantity + quantity},
      );
    } else {
      // Add new item
      await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _cartItemsCollection,
        documentId: ID.unique(),
        data: {
          'userId': userId,
          'productId': product.id,
          'productName': product.name,
          'price': product.price,
          'quantity': quantity,
          'imageUrl': product.imageUrl,
        },
      );
    }
  }

  @override
  Future<void> removeFromCart(String cartItemId) async {
    await _databases.deleteDocument(
      databaseId: _databaseId,
      collectionId: _cartItemsCollection,
      documentId: cartItemId,
    );
  }

  @override
  Future<void> updateQuantity(String cartItemId, int quantity) async {
    await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: _cartItemsCollection,
      documentId: cartItemId,
      data: {'quantity': quantity},
    );
  }

  @override
  Future<void> clearCart() async {
    final cartItems = await getCart();
    for (var item in cartItems) {
      await removeFromCart(item.id);
    }
  }

  @override
  Future<Order> placeOrder(List<CartItem> cartItems, String address) async {
    // Calculate total amount
    double totalAmount = 0;
    for (var item in cartItems) {
      totalAmount += (item.price * item.quantity);
    }

    // Create order
    final orderId = ID.unique();
    final order = await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: _ordersCollection,
      documentId: orderId,
      data: {
        'userId': userId,
        'totalAmount': totalAmount,
        'dateTime': DateTime.now().toIso8601String(),
        'status': 'pending',
        'address': address, // Now this is required
      },
    );

    // Create order items
    for (var item in cartItems) {
      await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _orderItemsCollection,
        documentId: ID.unique(),
        data: {
          'orderId': orderId,
          'productId': item.productId,
          'productName': item.productName,
          'price': item.price,
          'quantity': item.quantity,
        },
      );
    }

    // Clear the cart
    await clearCart();

    return Order.fromDoc(order);
  }

  @override
  Future<List<Order>> getUserOrders() async {
    final response = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _ordersCollection,
      queries: [Query.equal('userId', userId), Query.orderDesc('dateTime')],
    );

    return response.documents.map((doc) => Order.fromDoc(doc)).toList();
  }

  @override
  Future<List<OrderItem>> getOrderItems(String orderId) async {
    final response = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _orderItemsCollection,
      queries: [Query.equal('orderId', orderId)],
    );

    return response.documents.map((doc) => OrderItem.fromDoc(doc)).toList();
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    // Check if the order exists and belongs to the current user
    final response = await _databases.getDocument(
      databaseId: _databaseId,
      collectionId: _ordersCollection,
      documentId: orderId,
    );

    final Order order = Order.fromDoc(response);

    // Only allow cancellation if the order belongs to the current user and is pending
    if (order.userId == userId && order.status == 'pending') {
      await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _ordersCollection,
        documentId: orderId,
        data: {'status': 'canceled'}, // Update status to canceled
      );
    } else {
      throw Exception(
        'You cannot cancel this order. It may be already completed or belong to another user.',
      );
    }
  }
}

@riverpod
AppwriteMarketRepository marketRepository(Ref ref) {
  final database = Databases(ref.watch(appwriteClientProvider));
  final databaseId = "planty-db-id";
  final user = ref.watch(userProvider).value;
  return AppwriteMarketRepository(
    databases: database,
    databaseId: databaseId,
    userId: user?.$id ?? '',
  );
}
