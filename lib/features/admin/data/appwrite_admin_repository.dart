import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/features/auth/data/auth_repository.dart';
import 'package:plant_app/features/market/domain/entities.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'appwrite_admin_repository.g.dart';

abstract class AdminRepository {
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String productId);
  Future<List<Order>> getAllOrders();
  Future<Order> getOrderDetails(String orderId);
  Future<List<OrderItem>> getOrderItems(String orderId);
  Future<void> updateOrder(String orderId); // Mark as completed
  Future<void> updateOrderDetails(Order order); // Update all order details
  Future<void> deleteOrder(String orderId);
}

class AppwriteAdminRepository implements AdminRepository {
  final Databases _databases;
  final String _databaseId;

  // Collection IDs - using the same as market repository for consistency
  static const String _productsCollection = 'products';
  static const String _ordersCollection = 'orders';
  static const String _orderItemsCollection = 'order_items';

  AppwriteAdminRepository({required Databases databases, required String databaseId})
    : _databases = databases,
      _databaseId = databaseId;

  @override
  Future<void> addProduct(Product product) async {
    await _databases.createDocument(
      databaseId: _databaseId,
      collectionId: _productsCollection,
      documentId: ID.unique(),
      data: product.toMap(),
    );
  }

  @override
  Future<void> updateProduct(Product product) async {
    await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: _productsCollection,
      documentId: product.id,
      data: product.toMap(),
    );
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await _databases.deleteDocument(
      databaseId: _databaseId,
      collectionId: _productsCollection,
      documentId: productId,
    );
  }

  @override
  Future<List<Order>> getAllOrders() async {
    final response = await _databases.listDocuments(
      databaseId: _databaseId,
      collectionId: _ordersCollection,
      queries: [Query.orderDesc('dateTime')],
    );

    return response.documents.map((doc) => Order.fromDoc(doc)).toList();
  }

  @override
  Future<Order> getOrderDetails(String orderId) async {
    final response = await _databases.getDocument(
      databaseId: _databaseId,
      collectionId: _ordersCollection,
      documentId: orderId,
    );

    return Order.fromDoc(response);
  }

  @override
  Future<void> updateOrder(String orderId) async {
    await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: _ordersCollection,
      documentId: orderId,
      data: {'status': 'completed', 'dateTime': DateTime.now().toIso8601String()},
    );
  }

  @override
  Future<void> updateOrderDetails(Order order) async {
    await _databases.updateDocument(
      databaseId: _databaseId,
      collectionId: _ordersCollection,
      documentId: order.id,
      data: order.toMap(),
    );
  }

  // Additional helper method to get order items
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
  Future<void> deleteOrder(String orderId) async {
    await _databases.deleteDocument(
      databaseId: _databaseId,
      collectionId: _ordersCollection,
      documentId: orderId,
    );
  }
}

@riverpod
AppwriteAdminRepository adminRepository(Ref ref) {
  final database = Databases(ref.watch(appwriteClientProvider));
  final databaseId = "planty-db-id";
  return AppwriteAdminRepository(databases: database, databaseId: databaseId);
}
