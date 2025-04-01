import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/features/market/data/appwrite_market_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities.dart';
import '../controllers/market_controllers.dart';

part 'product_details_screen.g.dart';

@riverpod
Future<Product> productDetails(ProductDetailsRef ref, String id) {
  return ref.read(marketRepositoryProvider).getProductById(id);
}

class ProductDetailsScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailsProvider(productId));

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: productAsync.when(
        data:
            (product) => Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product images
                      AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.local_florist, size: 96, color: Colors.grey),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product name and price
                            Text(
                              product.name,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  product.isOnSale
                                      ? '\$${product.discountPrice.toStringAsFixed(2)}'
                                      : '\$${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: product.isOnSale ? Colors.red : Colors.green,
                                  ),
                                ),
                                if (product.isOnSale) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            // Rating and stock
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                ...List.generate(5, (index) {
                                  return Icon(
                                    index < product.rating ? Icons.star : Icons.star_border,
                                    color: Colors.amber,
                                  );
                                }),
                                const SizedBox(width: 8),
                                Text('(${product.reviewCount} reviews)'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.isInStock ? 'In Stock' : 'Out of Stock',
                              style: TextStyle(
                                color: product.isInStock ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // Description
                            const SizedBox(height: 24),
                            const Text(
                              'Description',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(product.description),

                            // Add some padding at the bottom for the floating button
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Add to cart button
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.1)),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed:
                          product.isInStock
                              ? () => _showQuantitySelector(context, ref, product)
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Add to Cart'),
                    ),
                  ),
                ),
              ],
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _showQuantitySelector(BuildContext context, WidgetRef ref, Product product) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _QuantitySelector(product: product),
    );
  }
}

class _QuantitySelector extends ConsumerStatefulWidget {
  final Product product;

  const _QuantitySelector({required this.product});

  @override
  ConsumerState<_QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends ConsumerState<_QuantitySelector> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (quantity > 1) setState(() => quantity--);
                },
                icon: const Icon(Icons.remove),
              ),
              const SizedBox(width: 16),
              Text(quantity.toString(), style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {
                  if (quantity < widget.product.stockQuantity) {
                    setState(() => quantity++);
                  }
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(cartNotifierProvider.notifier).addToCart(widget.product, quantity);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
