import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/core/constants/routes.dart';
import 'package:plant_app/features/market/domain/entities.dart';
import 'package:plant_app/features/market/presentation/controllers/market_controller.dart';
import 'package:plant_app/features/market/presentation/widgets/address_form.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItemsAsync = ref.watch(cartItemsProvider);
    ref.listen(cartControllerProvider, (previous, current) {
      if (current.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update cart: ${current.error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Shopping Cart'), elevation: 0),
      body: cartItemsAsync.when(
        data: (cartItems) {
          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('Your cart is empty', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(Routes.market);
                    },
                    child: const Text('Shop Now'),
                  ),
                ],
              ),
            );
          }

          // Use a StatefulBuilder to manage local cart state for smooth UI updates
          return _CartItemsList(initialItems: cartItems);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Center(
              child: Text(
                'Error loading cart: ${error.toString()}',
                textAlign: TextAlign.center,
              ),
            ),
      ),
    );
  }
}

// New stateful widget to manage cart items locally
class _CartItemsList extends ConsumerStatefulWidget {
  final List<CartItem> initialItems;

  const _CartItemsList({required this.initialItems});

  @override
  _CartItemsListState createState() => _CartItemsListState();
}

class _CartItemsListState extends ConsumerState<_CartItemsList> {
  late List<CartItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.initialItems);
  }

  void _removeItem(int index, CartItem item) {
    // Store the item reference before removal
    final removedItem = item;
    final removedItemName = item.productName;

    // Remove the item from the local state first
    setState(() {
      _items.removeAt(index);
    });

    // Show the snackbar immediately
    final snackBar = SnackBar(
      content: Text('$removedItemName removed from cart'),
      duration: const Duration(seconds: 2),
    );

    // Use the current context's ScaffoldMessenger
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Now trigger the actual database operation
    ref
        .read(cartControllerProvider.notifier)
        .removeFromCart(
          removedItem.userId,
          removedItem.id,
          null, // No callback needed since we already showed snackbar
          removedItem: removedItem,
        );
  }

  // Add a function to update the quantity locally
  void _updateQuantity(String cartItemId, int newQuantity) {
    setState(() {
      final index = _items.indexWhere((item) => item.id == cartItemId);
      if (index != -1) {
        _items[index] = _items[index].copyWith(quantity: newQuantity);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return CartItemCard(
                cartItem: _items[index],
                onDismissed: () => _removeItem(index, _items[index]),
                onQuantityChanged:
                    (newQuantity) => _updateQuantity(_items[index].id, newQuantity),
              );
            },
          ),
        ),
        CartSummary(cartItems: _items),
      ],
    );
  }
}

class CartItemCard extends ConsumerWidget {
  final CartItem cartItem;
  final VoidCallback onDismissed;
  final void Function(int) onQuantityChanged; // Add callback for quantity changes

  const CartItemCard({
    super.key,
    required this.cartItem,
    required this.onDismissed,
    required this.onQuantityChanged, // Add this parameter
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        // Only call the parent's onDismissed callback
        // which will handle both UI update and database operation
        onDismissed();
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(cartItem.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.productName,
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${cartItem.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    QuantitySelector(
                      cartItem: cartItem,
                      onQuantityChanged: onQuantityChanged, // Pass the callback
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuantitySelector extends ConsumerWidget {
  final CartItem cartItem;
  final void Function(int) onQuantityChanged; // Add callback

  const QuantitySelector({
    super.key,
    required this.cartItem,
    required this.onQuantityChanged, // Add this parameter
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartControllerState = ref.watch(cartControllerProvider);
    final isLoading = cartControllerState is AsyncLoading;

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              // Decrease quantity button
              IconButton(
                icon: const Icon(Icons.remove, size: 16),
                onPressed:
                    isLoading || cartItem.quantity <= 1
                        ? null
                        : () {
                          // Update quantity locally first for immediate feedback
                          final newQuantity = cartItem.quantity - 1;
                          onQuantityChanged(newQuantity);

                          // Then persist to backend
                          ref
                              .read(cartControllerProvider.notifier)
                              .updateQuantity(cartItem.userId, cartItem.id, newQuantity, null);
                        },
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                padding: EdgeInsets.zero,
              ),

              // Quantity display
              Text(cartItem.quantity.toString(), style: const TextStyle(fontSize: 14)),

              // Increase quantity button
              IconButton(
                icon: const Icon(Icons.add, size: 16),
                onPressed:
                    isLoading
                        ? null
                        : () {
                          // Update quantity locally first for immediate feedback
                          final newQuantity = cartItem.quantity + 1;
                          onQuantityChanged(newQuantity);

                          // Then persist to backend
                          ref
                              .read(cartControllerProvider.notifier)
                              .updateQuantity(cartItem.userId, cartItem.id, newQuantity, null);
                        },
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        const Spacer(),
        // Item total
        Text(
          '\$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class CartSummary extends ConsumerStatefulWidget {
  final List<CartItem> cartItems;

  const CartSummary({super.key, required this.cartItems});

  @override
  ConsumerState<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends ConsumerState<CartSummary> {
  bool _showAddressForm = false;

  void _proceedToAddress() {
    setState(() {
      _showAddressForm = true;
    });
  }

  void _placeOrder(String address) {
    // Hide the address form after submission
    setState(() {
      _showAddressForm = false;
    });

    ref.read(orderControllerProvider.notifier).placeOrder(
      widget.cartItems.first.userId,
      widget.cartItems,
      address, // Pass the address to the controller
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order placed successfully!'),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.of(context).pushReplacementNamed(Routes.marketOrders);
      },
    );
  }

  double calculateCartTotal(List<CartItem> items) {
    return items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    final total = calculateCartTotal(widget.cartItems);
    final orderControllerState = ref.watch(orderControllerProvider);
    final isProcessing = orderControllerState is AsyncLoading;

    // If showing address form, return it
    if (_showAddressForm) {
      return AddressForm(onAddressSubmitted: _placeOrder);
    }

    // Otherwise show the cart summary
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal', style: Theme.of(context).textTheme.titleMedium),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isProcessing ? null : _proceedToAddress,
                child:
                    isProcessing
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2.0,
                          ),
                        )
                        : const Text('Proceed to Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
