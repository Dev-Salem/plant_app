import 'package:plant_app/src/features/market/domain/entities.dart';

abstract class IAdminService {
  // Product/Stock Management
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String productId);

  // Order Management
  Future<List<Order>> getAllOrders();
  Future<Order> getOrderDetails(String orderId);
  Future<void> updateOrder(String orderId);
  Future<void> deleteOrder(String orderId);
}
