import 'package:plant_app/features/market/domain/entities.dart';

abstract class IMarketplaceService {
  Future<List<Product>> getProducts();

  Future<List<Product>> getProductsByCategory(String category);

  Future<Product> getProduct(String productId);

  Future<List<CartItem>> getCart();

  Future<void> addToCart(Product product, int quantity);

  Future<void> removeFromCart(String cartItemId);

  Future<void> updateQuantity(String cartItemId, int quantity);

  Future<void> clearCart();

  Future<Order> placeOrder(List<CartItem> cartItems, String address);

  Future<void> cancelOrder(String orderId); // New method to cancel an order

  Future<List<Order>> getUserOrders();

  Future<List<OrderItem>> getOrderItems(String orderId);
}
