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
    return result.documents.map((doc) => Product.fromJson(doc.data)).toList();
  }

  @override
  Future<Product> getProductById(String id) async {
    final doc = await _databases.getDocument(
      databaseId: _databaseId,
      collectionId: _productsCollection,
      documentId: id,
    );
    return Product.fromJson(doc.data);
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
    final result = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _cartsCollection,
      queries: [Query.equal('user_id', userId)],
    );

    if (result.documents.isEmpty) {
      final newCart = Cart(
        id: ID.unique(),
        userId: userId,
        items: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final doc = await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _cartsCollection,
        documentId: newCart.id,
        data: newCart.toJson(),
      );
      return Cart.fromJson(doc.data);
    }

    return Cart.fromJson(result.documents.first.data);
  }

  @override
  Future<bool> clearCart(String userId) async {
    final cart = await getCart(userId);
    await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: _cartsCollection,
      documentId: cart.id,
      data: {'items': []},
    );
    return true;
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
    final doc = await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: _cartsCollection,
      documentId: cart.id,
      data: cart.toJson(),
    );
    return Cart.fromJson(doc.data);
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
}

@riverpod
AppwriteMarketRepository marketRepository(Ref ref) {
  final database = Databases(ref.watch(appwriteClientProvider));
  final databaseId = "planty-db-id";
  return AppwriteMarketRepository(databases: database, databaseId: databaseId);
}
