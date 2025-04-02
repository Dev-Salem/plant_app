import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
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
      try {
        final cart = await ref.read(marketRepositoryProvider).getCart(userId);
        return cart;
      } catch (e) {
        // Log the error for debugging
        print('Error loading cart: $e');
        // Create a new cart if loading fails
        final newCart = Cart(
          id: Uuid().v4(),
          userId: userId,
          items: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        return await ref.read(marketRepositoryProvider).createCart(newCart);
      }
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

    // Start loading state
    state = AsyncValue.loading();

    try {
      final cart = state.value!;
      final existingItemIndex = cart.items.indexWhere((item) => item.product.id == product.id);

      final updatedItems = [...cart.items];
      if (existingItemIndex == -1) {
        // Add new item
        updatedItems.add(
          CartItem(
            id: product.id, // Use product ID as item ID for simplicity
            product: product,
            quantity: quantity,
          ),
        );
      } else {
        // Update existing item
        final existingItem = updatedItems[existingItemIndex];
        updatedItems[existingItemIndex] = CartItem(
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

      final result = await ref.read(marketRepositoryProvider).updateCart(updatedCart);
      state = AsyncValue.data(result);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      print('Error adding to cart: $e');
    }
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

  Future<void> createNewCart(String userId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final newCart = Cart(
        id: Uuid().v4(),
        userId: userId,
        items: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      return ref.read(marketRepositoryProvider).createCart(newCart);
    });
  }

  Future<void> addItemToCart(CartItem item) async {
    if (state.value == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(marketRepositoryProvider).addCartItem(state.value!.id, item);
      return ref.read(marketRepositoryProvider).getCart(state.value!.userId);
    });
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
