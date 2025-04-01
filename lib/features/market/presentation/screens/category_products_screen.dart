import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/features/market/data/appwrite_market_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/constants/routes.dart';
import '../../domain/entities.dart';
import '../widgets/product_card.dart';
import '../controllers/market_controllers.dart';

part 'category_products_screen.g.dart';

@riverpod
Future<List<Product>> categoryProducts(CategoryProductsRef ref, String categoryId) {
  return ref.read(marketRepositoryProvider).getProductsByCategory(categoryId);
}

@riverpod
Future<Category> categoryDetails(CategoryDetailsRef ref, String categoryId) {
  return ref.read(marketRepositoryProvider).getCategoryById(categoryId);
}

class CategoryProductsScreen extends ConsumerWidget {
  final String categoryId;

  const CategoryProductsScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(categoryProductsProvider(categoryId));
    final categoryAsync = ref.watch(categoryDetailsProvider(categoryId));

    return Scaffold(
      appBar: AppBar(
        title: categoryAsync.when(
          data: (category) => Text(category.name),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Category'),
        ),
      ),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text('No products in this category'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () => context.pushNamed(Routes.marketProduct, arguments: product.id),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
