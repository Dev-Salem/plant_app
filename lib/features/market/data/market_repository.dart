import 'package:plant_app/features/market/domain/entities.dart';

abstract class IMarketplaceService {
  Future<List<Product>> getProducts();

  Future<List<Product>> getProductsByCategory(String category);

  Future<Product> getProduct(String productId);

  Future<List<CartItem>> getCart(String userId);

  Future<void> addToCart(String userId, Product product, int quantity);

  Future<void> removeFromCart(String cartItemId);

  Future<void> updateQuantity(String cartItemId, int quantity);

  Future<void> clearCart(String userId);

  Future<Order> placeOrder(String userId, List<CartItem> cartItems, String? address);

  Future<List<Order>> getUserOrders(String userId);

  Future<List<OrderItem>> getOrderItems(String orderId);
}
