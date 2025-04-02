import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/core/constants/routes.dart';
import 'package:plant_app/features/market/domain/entities.dart';
import 'package:plant_app/features/market/presentation/controllers/market_controller.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailsProvider(productId));
    ref.listen(productsProvider, (previous, current) {
      if (current.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update product: ${current.error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.marketCart);
            },
          ),
        ],
      ),
      body: productAsync.when(
        data: (product) => _buildProductDetails(context, ref, product),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Center(
              child: Text(
                'Error loading product details: ${error.toString()}',
                textAlign: TextAlign.center,
              ),
            ),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context, WidgetRef ref, Product product) {
    // Watch the cart controller state to show loading indicator
    final cartControllerState = ref.watch(cartControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Hero(
            tag: 'product-${product.id}',
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.image, size: 50)),
                  ),
            ),
          ),
        ),

        // Product Information
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Category
              Chip(
                label: Text(product.category),
                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                'Description',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(product.description, style: Theme.of(context).textTheme.bodyMedium),

              const SizedBox(height: 32),

              // Add to Cart Button
            ],
          ),
        ),
        Spacer(),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed:
                cartControllerState.isLoading
                    ? null // Disable button while loading
                    : () {
                      // Add to cart using the CartController
                      ref.read(cartControllerProvider.notifier).addToCart(product, 1, () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Added to cart!'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      });
                    },
            icon:
                cartControllerState.isLoading
                    ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                    : const Icon(Icons.shopping_cart),
            label: Text(cartControllerState.isLoading ? 'Adding...' : 'Add to Cart'),
          ).paddingHorizontal(24),
        ),
      ],
    );
  }
}
