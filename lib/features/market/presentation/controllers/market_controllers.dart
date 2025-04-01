import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/appwrite_market_repository.dart';
import '../../domain/entities.dart';

part 'market_controllers.g.dart';

@riverpod
class Products extends _$Products {
  @override
  FutureOr<List<Product>> build() async {
    return ref.read(marketRepositoryProvider).getProducts();
  }

  Future<void> addProduct(Product product, VoidCallback onSuccess) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final newProduct = await ref.read(marketRepositoryProvider).createProduct(product);
      return [...?state.value, newProduct];
    });
    if (!state.hasError) onSuccess();
  }

  Future<void> updateProduct(Product product) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final updatedProduct = await ref.read(marketRepositoryProvider).updateProduct(product);
      return state.value?.map((p) => p.id == product.id ? updatedProduct : p).toList() ?? [];
    });
  }

  Future<void> deleteProduct(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(marketRepositoryProvider).deleteProduct(id);
      return state.value?.where((p) => p.id != id).toList() ?? [];
    });
  }
}

@riverpod
class Categories extends _$Categories {
  @override
  FutureOr<List<Category>> build() async {
    return ref.read(marketRepositoryProvider).getCategories();
  }

  Future<void> addCategory(Category category, VoidCallback onSuccess) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final newCategory = await ref.read(marketRepositoryProvider).createCategory(category);
      return [...?state.value, newCategory];
    });
    if (!state.hasError) onSuccess();
  }
}

@riverpod
class CartNotifier extends _$CartNotifier {
  @override
  FutureOr<Cart?> build() async {
    return null; // Cart is loaded when user logs in
  }

  Future<void> loadCart(String userId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(marketRepositoryProvider).getCart(userId);
    });
  }

  Future<void> updateCart(Cart cart) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(marketRepositoryProvider).updateCart(cart);
    });
  }

  Future<void> addToCart(Product product, int quantity) async {
    if (state.value == null) return;

    final cart = state.value!;
    final existingItem = cart.items.firstWhere(
      (item) => item.product.id == product.id,
      orElse:
          () => CartItem(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            product: product,
            quantity: 0,
          ),
    );

    final updatedItems = [...cart.items];
    if (existingItem.quantity == 0) {
      updatedItems.add(CartItem(id: existingItem.id, product: product, quantity: quantity));
    } else {
      final index = updatedItems.indexOf(existingItem);
      updatedItems[index] = CartItem(
        id: existingItem.id,
        product: product,
        quantity: existingItem.quantity + quantity,
      );
    }

    final updatedCart = Cart(
      id: cart.id,
      userId: cart.userId,
      items: updatedItems,
      createdAt: cart.createdAt,
      updatedAt: DateTime.now(),
    );

    await updateCart(updatedCart);
  }

  Future<void> clearCart() async {
    if (state.value == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(marketRepositoryProvider).clearCart(state.value!.userId);
      return state.value!.copyWith(items: []);
    });
  }

  Future<void> updateItemQuantity(Product product, int newQuantity) async {
    if (state.value == null) return;
    if (newQuantity < 0) return;

    final cart = state.value!;
    final updatedItems = [...cart.items];
    final itemIndex = updatedItems.indexWhere((item) => item.product.id == product.id);

    if (itemIndex != -1) {
      if (newQuantity == 0) {
        updatedItems.removeAt(itemIndex);
      } else {
        updatedItems[itemIndex] = CartItem(
          id: updatedItems[itemIndex].id,
          product: product,
          quantity: newQuantity,
        );
      }

      final updatedCart = cart.copyWith(items: updatedItems, updatedAt: DateTime.now());

      await updateCart(updatedCart);
    }
  }
}

@riverpod
class Orders extends _$Orders {
  @override
  FutureOr<List<Order>> build() async {
    return [];
  }

  Future<void> loadOrders(String userId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(marketRepositoryProvider).getOrders(userId);
    });
  }

  Future<void> createOrder(Order order, VoidCallback onSuccess) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final newOrder = await ref.read(marketRepositoryProvider).createOrder(order);
      return [...?state.value, newOrder];
    });
    if (!state.hasError) onSuccess();
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final updatedOrder = await ref
          .read(marketRepositoryProvider)
          .updateOrderStatus(orderId, status);
      return state.value?.map((o) => o.id == orderId ? updatedOrder : o).toList() ?? [];
    });
  }
}
