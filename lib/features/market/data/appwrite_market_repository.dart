import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/features/auth/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/entities.dart';
import 'market_repository.dart';
part 'appwrite_market_repository.g.dart';

class AppwriteMarketRepository implements MarketRepository {
  final Databases _databases;
  final String _databaseId;

  // Collection IDs
  static const String _productsCollection = 'products';
  static const String _categoriesCollection = 'categories';
  static const String _cartsCollection = 'carts';
  static const String _ordersCollection = 'orders';
  static const String _reviewsCollection = 'reviews';

  AppwriteMarketRepository({required Databases databases, required String databaseId})
    : _databases = databases,
      _databaseId = databaseId;

  @override
  Future<List<Product>> getProducts() async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _productsCollection,
    );
    return result.documents.map((doc) {
      try {
        return Product.fromJson(doc.data);
      } catch (e, stackTrace) {
        rethrow;
      }
    }).toList();
  }

  @override
  Future<Product> getProductById(String id) async {
    final doc = await _databases.getDocument(
      databaseId: _databaseId,
      collectionId: _productsCollection,
      documentId: id,
    );
    try {
      return Product.fromJson(doc.data);
    } catch (e, stackTrace) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _productsCollection,
      queries: [Query.equal('category.id', categoryId)],
    );
    return result.documents.map((doc) => Product.fromJson(doc.data)).toList();
  }

  @override
  Future<List<Product>> getFeaturedProducts() async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _productsCollection,
      queries: [Query.equal('is_featured', true)],
    );
    return result.documents.map((doc) => Product.fromJson(doc.data)).toList();
  }

  @override
  Future<Product> createProduct(Product product) async {
    final doc = await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: _productsCollection,
      documentId: ID.unique(),
      data: product.toJson(),
    );
    return Product.fromJson(doc.data);
  }

  @override
  Future<Cart> getCart(String userId) async {
    try {
      log('Fetching cart for user: $userId');
      final result = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _cartsCollection,
        queries: [Query.equal('user_id', userId)],
      );

      if (result.documents.isEmpty) {
        log('No existing cart found. Creating new cart for user: $userId');
        return await _createNewCart(userId);
      }

      log('Found existing cart: ${result.documents.first.data}');
      final cartData = result.documents.first.data;

      // We need to load product details for each item ID in the cart
      final List<dynamic> itemIds = cartData['items'] as List<dynamic>? ?? [];
      final List<CartItem> resolvedItems = [];

      for (var itemId in itemIds) {
        try {
          // Fetch product details for each item
          final product = await getProductById(itemId.toString());

          resolvedItems.add(
            CartItem(
              id: itemId.toString(),
              product: product,
              quantity: 1, // Default quantity - you'd need to store this properly
            ),
          );
        } catch (e) {
          log('Error fetching product $itemId: $e');
          // Skip this item if it can't be loaded
        }
      }

      // Return cart with resolved items
      return Cart(
        id: cartData['id'] as String,
        userId: cartData['user_id'] as String,
        items: resolvedItems,
        createdAt: DateTime.parse(cartData['created_at'] as String),
        updatedAt: DateTime.parse(cartData['updated_at'] as String),
      );
    } catch (e, stackTrace) {
      log('Error getting cart for user $userId', error: e, stackTrace: stackTrace);

      // If there's any error (like document not found), create a new cart
      if (e.toString().contains('document_not_found')) {
        log('Cart not found, creating new cart for user: $userId');
        return await _createNewCart(userId);
      }

      rethrow;
    }
  }

  // Helper method to create a new cart
  Future<Cart> _createNewCart(String userId) async {
    try {
      final newCart = Cart(
        id: ID.unique(),
        userId: userId,
        items: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      log('Creating new cart with data: ${newCart.toJson()}');

      final doc = await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _cartsCollection,
        documentId: newCart.id,
        data: {
          'id': newCart.id,
          'user_id': newCart.userId,
          'items': [], // Empty array for new cart
          'created_at': newCart.createdAt.toIso8601String(),
          'updated_at': newCart.updatedAt.toIso8601String(),
        },
      );

      log('New cart created successfully: ${doc.data}');
      return newCart; // Return the cart object since it doesn't have items to resolve
    } catch (e, stackTrace) {
      log('Failed to create new cart: $e', error: e, stackTrace: stackTrace);
      throw Exception('Failed to create cart: $e');
    }
  }

  @override
  Future<bool> clearCart(String userId) async {
    try {
      // Try to find the cart first
      final result = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _cartsCollection,
        queries: [Query.equal('user_id', userId)],
      );

      if (result.documents.isEmpty) {
        // No cart to clear
        log('No cart found to clear for user: $userId');
        return true;
      }

      final cartId = result.documents.first.data['id'] as String;

      await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _cartsCollection,
        documentId: cartId,
        data: {'items': []},
      );
      log('Cart cleared successfully for user: $userId');
      return true;
    } catch (e, stackTrace) {
      log('Error clearing cart for user $userId', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<Category> createCategory(Category category) async {
    final doc = await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: _categoriesCollection,
      documentId: ID.unique(),
      data: category.toJson(),
    );
    return Category.fromJson(doc.data);
  }

  @override
  Future<Order> createOrder(Order order) async {
    final doc = await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: _ordersCollection,
      documentId: ID.unique(),
      data: order.toJson(),
    );
    return Order.fromJson(doc.data);
  }

  @override
  Future<Review> createReview(Review review) async {
    final doc = await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: _reviewsCollection,
      documentId: ID.unique(),
      data: review.toJson(),
    );
    return Review.fromJson(doc.data);
  }

  @override
  Future<bool> deleteCategory(String id) async {
    await _databases.deleteDocument(
      databaseId: _databaseId,
      collectionId: _categoriesCollection,
      documentId: id,
    );
    return true;
  }

  @override
  Future<bool> deleteProduct(String id) async {
    await _databases.deleteDocument(
      databaseId: _databaseId,
      collectionId: _productsCollection,
      documentId: id,
    );
    return true;
  }

  @override
  Future<bool> deleteReview(String id) async {
    await _databases.deleteDocument(
      databaseId: _databaseId,
      collectionId: _reviewsCollection,
      documentId: id,
    );
    return true;
  }

  @override
  Future<List<Category>> getCategories() async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _categoriesCollection,
    );
    return result.documents.map((doc) => Category.fromJson(doc.data)).toList();
  }

  @override
  Future<Category> getCategoryById(String id) async {
    final doc = await _databases.getDocument(
      databaseId: _databaseId,
      collectionId: _categoriesCollection,
      documentId: id,
    );
    return Category.fromJson(doc.data);
  }

  @override
  Future<Order> getOrderById(String id) async {
    final doc = await _databases.getDocument(
      databaseId: _databaseId,
      collectionId: _ordersCollection,
      documentId: id,
    );
    return Order.fromJson(doc.data);
  }

  @override
  Future<List<Order>> getOrders(String userId) async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _ordersCollection,
      queries: [Query.equal('user_id', userId)],
    );
    return result.documents.map((doc) => Order.fromJson(doc.data)).toList();
  }

  @override
  Future<List<Review>> getProductReviews(String productId) async {
    final result = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _reviewsCollection,
      queries: [Query.equal('product_id', productId)],
    );
    return result.documents.map((doc) => Review.fromJson(doc.data)).toList();
  }

  @override
  Future<Cart> updateCart(Cart cart) async {
    try {
      log('Updating cart ${cart.id} with ${cart.items.length} items');

      // Ensure items are mapped to just IDs for the database
      final cartData = {
        'user_id': cart.userId,
        'items': cart.items.map((item) => item.product.id).toList(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      log('Cart JSON data to be sent: $cartData');

      final doc = await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _cartsCollection,
        documentId: cart.id,
        data: cartData,
      );

      log('Cart updated successfully');

      // Return the updated cart with full details
      return cart;
    } catch (e, stackTrace) {
      log('Error updating cart ${cart.id}', error: e, stackTrace: stackTrace);

      // If the cart doesn't exist, create it
      if (e.toString().contains('document_not_found')) {
        log('Cart not found during update, creating a new one');
        final newCart = await _createNewCart(cart.userId);

        // Then try the update again with the new cart ID
        return updateCart(cart.copyWith(id: newCart.id));
      }

      rethrow;
    }
  }

  @override
  Future<Category> updateCategory(Category category) async {
    final doc = await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: _categoriesCollection,
      documentId: category.id,
      data: category.toJson(),
    );
    return Category.fromJson(doc.data);
  }

  @override
  Future<Order> updateOrderStatus(String id, OrderStatus status) async {
    final doc = await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: _ordersCollection,
      documentId: id,
      data: {'status': status.name},
    );
    return Order.fromJson(doc.data);
  }

  @override
  Future<Product> updateProduct(Product product) async {
    final doc = await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: _productsCollection,
      documentId: product.id,
      data: product.toJson(),
    );
    return Product.fromJson(doc.data);
  }

  @override
  Future<Cart> createCart(Cart cart) async {
    final doc = await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: _cartsCollection,
      documentId: cart.id,
      data: cart.toJson(),
    );
    return Cart.fromJson(doc.data);
  }

  @override
  Future<CartItem> addCartItem(String cartId, CartItem item) async {
    final cart = await getCart(cartId);
    final updatedItems = [...cart.items, item];

    final doc = await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: _cartsCollection,
      documentId: cartId,
      data: {'items': updatedItems.map((i) => i.toJson()).toList()},
    );

    return CartItem.fromJson(doc.data['items'].last);
  }
}

@riverpod
AppwriteMarketRepository marketRepository(Ref ref) {
  final database = Databases(ref.watch(appwriteClientProvider));
  final databaseId = "planty-db-id";
  return AppwriteMarketRepository(databases: database, databaseId: databaseId);
}
