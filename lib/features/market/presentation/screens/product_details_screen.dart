import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/features/market/domain/entities.dart';
import 'package:plant_app/features/market/presentation/controllers/market_controller.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailsProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to cart
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
            onPressed: () {
              // Add to cart functionality
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('${product.name} added to cart')));
            },
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Add to Cart'),
          ).paddingHorizontal(24),
        ),
      ],
    );
  }
}
