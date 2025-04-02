// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productsHash() => r'254e478700f769e8d792bcf2084fdb83c7329254';

/// See also [Products].
@ProviderFor(Products)
final productsProvider =
    AutoDisposeAsyncNotifierProvider<Products, List<Product>>.internal(
      Products.new,
      name: r'productsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product') ? null : _$productsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Products = AutoDisposeAsyncNotifier<List<Product>>;
String _$categoriesHash() => r'5ab4595393f3756dcdbf41bd03acbe981cffead3';

/// See also [Categories].
@ProviderFor(Categories)
final categoriesProvider =
    AutoDisposeAsyncNotifierProvider<Categories, List<Category>>.internal(
      Categories.new,
      name: r'categoriesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$categoriesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Categories = AutoDisposeAsyncNotifier<List<Category>>;
String _$cartNotifierHash() => r'1ee40c6e499468c7b2a3c0df6ae712444fe5b759';

/// See also [CartNotifier].
@ProviderFor(CartNotifier)
final cartNotifierProvider =
    AutoDisposeAsyncNotifierProvider<CartNotifier, Cart?>.internal(
      CartNotifier.new,
      name: r'cartNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$cartNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CartNotifier = AutoDisposeAsyncNotifier<Cart?>;
String _$ordersHash() => r'45fce17078f35ca7a0240db3368e322e27e89cff';

/// See also [Orders].
@ProviderFor(Orders)
final ordersProvider =
    AutoDisposeAsyncNotifierProvider<Orders, List<Order>>.internal(
      Orders.new,
      name: r'ordersProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product') ? null : _$ordersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Orders = AutoDisposeAsyncNotifier<List<Order>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
