import 'dart:developer';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/routes.dart';
import '../controllers/market_controllers.dart';
import '../widgets/product_card.dart';

class MarketScreen extends ConsumerWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Plant Market'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.pushNamed(Routes.marketCart),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(productsProvider);
          ref.invalidate(categoriesProvider);
        },
        child: CustomScrollView(
          slivers: [
            // Categories
            SliverToBoxAdapter(
              child: SizedBox(
                height: 120,
                child: categoriesAsync.when(
                  data:
                      (categories) => ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return GestureDetector(
                            onTap:
                                () => context.pushNamed(
                                  Routes.marketCategory,
                                  arguments: category.id,
                                ),
                            child: Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 8),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 35,
                                    backgroundImage: NetworkImage(category.imageUrl),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category.name,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, s) {
                    return Center(child: Text('Error: $e'));
                  },
                ),
              ),
            ),

            // Products Grid
            productsAsync.when(
              data:
                  (products) => SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final product = products[index];
                        return ProductCard(
                          product: product,
                          onTap:
                              () => context.pushNamed(
                                Routes.marketProduct,
                                arguments: product.id,
                              ),
                        );
                      }, childCount: products.length),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                    ),
                  ),
              loading:
                  () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
              error: (e, s) {
                log(e.toString());
                log(s.toString());
                return SliverFillRemaining(child: Center(child: Text('Error: $e')));
              },
            ),
          ],
        ),
      ),
    );
  }
}
