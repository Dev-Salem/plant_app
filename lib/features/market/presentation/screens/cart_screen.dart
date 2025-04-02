import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/features/market/presentation/controllers/cart_provider.dart';
import 'package:plant_app/features/market/presentation/screens/order_confirmation_screen.dart';
import 'package:plant_app/features/market/presentation/screens/shipping_address_form.dart';
import '../../domain/entities.dart';
import '../controllers/market_controllers.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(userCartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        actions: [
          Consumer(
            builder: (context, ref, _) {
              final cartCount = ref.watch(cartItemCountProvider);
              return cartCount.when(
                data:
                    (count) =>
                        count > 0
                            ? TextButton(
                              onPressed: () => clearCart(ref),
                              child: const Text('Clear'),
                            )
                            : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
      body: cartAsync.when(
        data: (cart) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Your cart is empty'),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return _CartItemTile(item: item);
                  },
                ),
              ),
              _CartSummary(cart: cart),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(userCartProvider),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}

class _CartItemTile extends ConsumerWidget {
  final CartItem item;

  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          color: Colors.grey[200],
          child: const Icon(Icons.local_florist, size: 32, color: Colors.grey),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                '\$${item.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.green),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                updateCartItemQuantity(ref, item.product.id, item.quantity - 1);
              },
            ),
            Text(item.quantity.toString()),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                updateCartItemQuantity(ref, item.product.id, item.quantity + 1);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _CartSummary extends ConsumerWidget {
  final Cart cart;

  const _CartSummary({required this.cart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.1))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('Subtotal'), Text('\$${cart.subtotal.toStringAsFixed(2)}')],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _processCheckout(context, ref, cart),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('Checkout'),
          ),
        ],
      ),
    );
  }

  void _processCheckout(BuildContext context, WidgetRef ref, Cart cart) async {
    // Show address form before creating order
    if (!context.mounted) return;

    final result = await Navigator.of(context).push<(Address, Address)>(
      MaterialPageRoute(
        builder:
            (_) => ShippingAddressForm(
              onSubmit: (shipping, billing) {
                Navigator.of(context).pop((shipping, billing));
              },
            ),
      ),
    );

    if (result == null || !context.mounted) return;

    final (shippingAddress, billingAddress) = result;

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: cart.userId,
      items: cart.items,
      status: OrderStatus.pending,
      total: cart.subtotal,
      shippingAddress: shippingAddress,
      subtotal: cart.subtotal,
      tax: 0,
      shippingCost: 30,
      paymentMethod: "Credit Card",
      billingAddress: billingAddress,
      createdAt: DateTime.now(),
    );

    await ref.read(ordersProvider.notifier).createOrder(order, () async {
      await ref.read(cartNotifierProvider.notifier).clearCart();
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => OrderConfirmationScreen(order: order)),
        );
      }
    });
  }
}
