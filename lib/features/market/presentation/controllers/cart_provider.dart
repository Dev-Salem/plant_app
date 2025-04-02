import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/appwrite_market_repository.dart';
import '../../domain/entities.dart';
import '../../../auth/data/auth_repository.dart';

part 'cart_provider.g.dart';

/// Provider that fetches the current user's cart
@riverpod
Future<Cart> userCart(UserCartRef ref) async {
  // Get the current user
  final user = await ref.watch(authRepositoryProvider).getAccount();

  if (user == null) {
    throw Exception('User not logged in');
  }

  // Get the cart from the repository
  return ref.watch(marketRepositoryProvider).getCart(user.$id);
}

/// Provider for the total number of items in the cart
@riverpod
Future<int> cartItemCount(CartItemCountRef ref) async {
  try {
    final cart = await ref.watch(userCartProvider.future);
    return cart.items.fold<int>(0, (sum, item) => sum + (item.quantity));
  } catch (e) {
    // Return 0 if the cart can't be loaded or user is not logged in
    return 0;
  }
}

/// Provider for the cart subtotal
@riverpod
Future<double> cartSubtotal(CartSubtotalRef ref) async {
  try {
    final cart = await ref.watch(userCartProvider.future);
    return cart.subtotal;
  } catch (e) {
    // Return 0 if the cart can't be loaded or user is not logged in
    return 0.0;
  }
}

/// Provider for getting a specific product from the cart
@riverpod
Future<CartItem?> cartItemByProductId(CartItemByProductIdRef ref, String productId) async {
  try {
    final cart = await ref.watch(userCartProvider.future);
    return cart.items.firstWhere(
      (item) => item.product.id == productId,
      orElse: () => throw Exception('Product not in cart'),
    );
  } catch (e) {
    // Return null if the product is not in the cart
    return null;
  }
}

/// Function to add an item to the cart
Future<void> addToCart(WidgetRef ref, Product product, int quantity) async {
  try {
    // Get the current cart
    final cart = await ref.read(userCartProvider.future);

    // Find existing item or create new one
    final existingItemIndex = cart.items.indexWhere((item) => item.product.id == product.id);
    final updatedItems = [...cart.items];

    if (existingItemIndex == -1) {
      // Add new item
      updatedItems.add(CartItem(id: product.id, product: product, quantity: quantity));
    } else {
      // Update existing item
      final existingItem = updatedItems[existingItemIndex];
      updatedItems[existingItemIndex] = CartItem(
        id: existingItem.id,
        product: product,
        quantity: existingItem.quantity + quantity,
      );
    }

    // Update the cart
    final updatedCart = cart.copyWith(items: updatedItems, updatedAt: DateTime.now());

    // Save the updated cart
    await ref.read(marketRepositoryProvider).updateCart(updatedCart);

    // Refresh the cart provider
    ref.invalidate(userCartProvider);
  } catch (e) {
    rethrow;
  }
}

/// Function to remove an item from the cart
Future<void> removeFromCart(WidgetRef ref, String productId) async {
  try {
    // Get the current cart
    final cart = await ref.read(userCartProvider.future);

    // Remove the item
    final updatedItems = cart.items.where((item) => item.product.id != productId).toList();

    // Update the cart
    final updatedCart = cart.copyWith(items: updatedItems, updatedAt: DateTime.now());

    // Save the updated cart
    await ref.read(marketRepositoryProvider).updateCart(updatedCart);

    // Refresh the cart provider
    ref.invalidate(userCartProvider);
  } catch (e) {
    rethrow;
  }
}

/// Function to update item quantity
Future<void> updateCartItemQuantity(WidgetRef ref, String productId, int newQuantity) async {
  try {
    if (newQuantity <= 0) {
      return removeFromCart(ref, productId);
    }

    // Get the current cart
    final cart = await ref.read(userCartProvider.future);

    // Update the item
    final updatedItems = [...cart.items];
    final itemIndex = updatedItems.indexWhere((item) => item.product.id == productId);

    if (itemIndex != -1) {
      final item = updatedItems[itemIndex];
      updatedItems[itemIndex] = item.copyWith(quantity: newQuantity);

      // Update the cart
      final updatedCart = cart.copyWith(items: updatedItems, updatedAt: DateTime.now());

      // Save the updated cart
      await ref.read(marketRepositoryProvider).updateCart(updatedCart);

      // Refresh the cart provider
      ref.invalidate(userCartProvider);
    }
  } catch (e) {
    rethrow;
  }
}

/// Function to clear the cart
Future<void> clearCart(WidgetRef ref) async {
  try {
    // Get the current cart
    final cart = await ref.read(userCartProvider.future);

    // Clear the cart in the repository
    await ref.read(marketRepositoryProvider).clearCart(cart.userId);

    // Refresh the cart provider
    ref.invalidate(userCartProvider);
  } catch (e) {
    rethrow;
  }
}
