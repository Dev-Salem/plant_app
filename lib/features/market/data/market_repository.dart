import '../domain/entities.dart';

abstract class MarketRepository {
  // Product operations
  Future<List<Product>> getProducts();
  Future<Product> getProductById(String id);
  Future<List<Product>> getProductsByCategory(String categoryId);
  Future<List<Product>> getFeaturedProducts();
  Future<Product> createProduct(Product product);
  Future<Product> updateProduct(Product product);
  Future<bool> deleteProduct(String id);

  // Category operations
  Future<List<Category>> getCategories();
  Future<Category> getCategoryById(String id);
  Future<Category> createCategory(Category category);
  Future<Category> updateCategory(Category category);
  Future<bool> deleteCategory(String id);

  // Cart operations
  Future<Cart> getCart(String userId);
  Future<Cart> updateCart(Cart cart);
  Future<bool> clearCart(String userId);

  // Order operations
  Future<List<Order>> getOrders(String userId);
  Future<Order> getOrderById(String id);
  Future<Order> createOrder(Order order);
  Future<Order> updateOrderStatus(String id, OrderStatus status);

  // Review operations
  Future<List<Review>> getProductReviews(String productId);
  Future<Review> createReview(Review review);
  Future<bool> deleteReview(String id);
}
