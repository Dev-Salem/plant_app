import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/appwrite_market_repository.dart';
import '../../domain/entities.dart';

part 'market_controller.g.dart';

// ============ Read-only Providers (for lists) ============

@riverpod
Future<List<Product>> products(Ref ref) {
  return ref.watch(marketRepositoryProvider).getProducts();
}

@riverpod
Future<List<Product>> productsByCategory(Ref ref, String category) {
  return ref.watch(marketRepositoryProvider).getProductsByCategory(category);
}

@riverpod
Future<Product> productDetails(Ref ref, String productId) {
  return ref.watch(marketRepositoryProvider).getProduct(productId);
}

@riverpod
Future<List<CartItem>> cartItems(Ref ref) {
  return ref.watch(marketRepositoryProvider).getCart();
}

@riverpod
Future<List<Order>> userOrders(Ref ref) {
  return ref.watch(marketRepositoryProvider).getUserOrders();
}

@riverpod
Future<List<OrderItem>> orderItems(Ref ref, String orderId) {
  return ref.watch(marketRepositoryProvider).getOrderItems(orderId);
}

// ============ Cart Controller (mutations) ============

@riverpod
class CartController extends _$CartController {
  @override
  FutureOr<void> build() async {}

  Future<void> addToCart(
    Product product,
    int quantity,
    VoidCallback? onSuccess,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(marketRepositoryProvider).addToCart(product, quantity);
      // Invalidate cart items provider to refresh UI
      ref.invalidate(cartItemsProvider);
    });
    if (!state.hasError && onSuccess != null) {
      onSuccess();
    }
  }

  Future<void> removeFromCart(
    String userId,
    String cartItemId,
    VoidCallback? onSuccess,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(marketRepositoryProvider).removeFromCart(cartItemId);
      // Invalidate cart items provider to refresh UI
      ref.invalidate(cartItemsProvider);
    });
    if (!state.hasError && onSuccess != null) {
      onSuccess();
    }
  }

  Future<void> updateQuantity(
    String userId,
    String cartItemId,
    int quantity,
    VoidCallback? onSuccess,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(marketRepositoryProvider).updateQuantity(cartItemId, quantity);
      // Invalidate cart items provider to refresh UI
      ref.invalidate(cartItemsProvider);
    });
    if (!state.hasError && onSuccess != null) {
      onSuccess();
    }
  }

  Future<void> clearCart(String userId, VoidCallback? onSuccess) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(marketRepositoryProvider).clearCart();
      // Invalidate cart items provider to refresh UI
      ref.invalidate(cartItemsProvider);
    });
    if (!state.hasError && onSuccess != null) {
      onSuccess();
    }
  }
}

// ============ Order Controller (mutations) ============

@riverpod
class OrderController extends _$OrderController {
  @override
  FutureOr<void> build() async {}

  Future<void> placeOrder(
    String userId,
    List<CartItem> cartItems,
    String? address,
    VoidCallback? onSuccess,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(marketRepositoryProvider).placeOrder(cartItems, address);
      // Invalidate both cart and orders providers to refresh UI
      ref.invalidate(cartItemsProvider);
      ref.invalidate(userOrdersProvider);
    });
    if (!state.hasError && onSuccess != null) {
      onSuccess();
    }
  }
}

// Helper function to calculate cart total
double calculateCartTotal(List<CartItem> items) {
  return items.fold(0.0, (total, item) => total + (item.price * item.quantity));
}
