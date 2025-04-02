// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'market_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productsHash() => r'8c28018c15ad13f10a4c6f6c01b3ac7e8823bcee';

/// See also [products].
@ProviderFor(products)
final productsProvider = AutoDisposeFutureProvider<List<Product>>.internal(
  products,
  name: r'productsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$productsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProductsRef = AutoDisposeFutureProviderRef<List<Product>>;
String _$productsByCategoryHash() =>
    r'b672faca33fb2e5e07690143b018649fcec5e9bc';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [productsByCategory].
@ProviderFor(productsByCategory)
const productsByCategoryProvider = ProductsByCategoryFamily();

/// See also [productsByCategory].
class ProductsByCategoryFamily extends Family<AsyncValue<List<Product>>> {
  /// See also [productsByCategory].
  const ProductsByCategoryFamily();

  /// See also [productsByCategory].
  ProductsByCategoryProvider call(String category) {
    return ProductsByCategoryProvider(category);
  }

  @override
  ProductsByCategoryProvider getProviderOverride(
    covariant ProductsByCategoryProvider provider,
  ) {
    return call(provider.category);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productsByCategoryProvider';
}

/// See also [productsByCategory].
class ProductsByCategoryProvider
    extends AutoDisposeFutureProvider<List<Product>> {
  /// See also [productsByCategory].
  ProductsByCategoryProvider(String category)
    : this._internal(
        (ref) => productsByCategory(ref as ProductsByCategoryRef, category),
        from: productsByCategoryProvider,
        name: r'productsByCategoryProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$productsByCategoryHash,
        dependencies: ProductsByCategoryFamily._dependencies,
        allTransitiveDependencies:
            ProductsByCategoryFamily._allTransitiveDependencies,
        category: category,
      );

  ProductsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final String category;

  @override
  Override overrideWith(
    FutureOr<List<Product>> Function(ProductsByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductsByCategoryProvider._internal(
        (ref) => create(ref as ProductsByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Product>> createElement() {
    return _ProductsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsByCategoryProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductsByCategoryRef on AutoDisposeFutureProviderRef<List<Product>> {
  /// The parameter `category` of this provider.
  String get category;
}

class _ProductsByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<Product>>
    with ProductsByCategoryRef {
  _ProductsByCategoryProviderElement(super.provider);

  @override
  String get category => (origin as ProductsByCategoryProvider).category;
}

String _$productDetailsHash() => r'4960605a6ce9cd7124ed7d6b9226c252db7e9c42';

/// See also [productDetails].
@ProviderFor(productDetails)
const productDetailsProvider = ProductDetailsFamily();

/// See also [productDetails].
class ProductDetailsFamily extends Family<AsyncValue<Product>> {
  /// See also [productDetails].
  const ProductDetailsFamily();

  /// See also [productDetails].
  ProductDetailsProvider call(String productId) {
    return ProductDetailsProvider(productId);
  }

  @override
  ProductDetailsProvider getProviderOverride(
    covariant ProductDetailsProvider provider,
  ) {
    return call(provider.productId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productDetailsProvider';
}

/// See also [productDetails].
class ProductDetailsProvider extends AutoDisposeFutureProvider<Product> {
  /// See also [productDetails].
  ProductDetailsProvider(String productId)
    : this._internal(
        (ref) => productDetails(ref as ProductDetailsRef, productId),
        from: productDetailsProvider,
        name: r'productDetailsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$productDetailsHash,
        dependencies: ProductDetailsFamily._dependencies,
        allTransitiveDependencies:
            ProductDetailsFamily._allTransitiveDependencies,
        productId: productId,
      );

  ProductDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final String productId;

  @override
  Override overrideWith(
    FutureOr<Product> Function(ProductDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProductDetailsProvider._internal(
        (ref) => create(ref as ProductDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Product> createElement() {
    return _ProductDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailsProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductDetailsRef on AutoDisposeFutureProviderRef<Product> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _ProductDetailsProviderElement
    extends AutoDisposeFutureProviderElement<Product>
    with ProductDetailsRef {
  _ProductDetailsProviderElement(super.provider);

  @override
  String get productId => (origin as ProductDetailsProvider).productId;
}

String _$cartItemsHash() => r'25159608253f0fa986733287ceebe631def411a5';

/// See also [cartItems].
@ProviderFor(cartItems)
const cartItemsProvider = CartItemsFamily();

/// See also [cartItems].
class CartItemsFamily extends Family<AsyncValue<List<CartItem>>> {
  /// See also [cartItems].
  const CartItemsFamily();

  /// See also [cartItems].
  CartItemsProvider call(String userId) {
    return CartItemsProvider(userId);
  }

  @override
  CartItemsProvider getProviderOverride(covariant CartItemsProvider provider) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'cartItemsProvider';
}

/// See also [cartItems].
class CartItemsProvider extends AutoDisposeFutureProvider<List<CartItem>> {
  /// See also [cartItems].
  CartItemsProvider(String userId)
    : this._internal(
        (ref) => cartItems(ref as CartItemsRef, userId),
        from: cartItemsProvider,
        name: r'cartItemsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$cartItemsHash,
        dependencies: CartItemsFamily._dependencies,
        allTransitiveDependencies: CartItemsFamily._allTransitiveDependencies,
        userId: userId,
      );

  CartItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<List<CartItem>> Function(CartItemsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CartItemsProvider._internal(
        (ref) => create(ref as CartItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<CartItem>> createElement() {
    return _CartItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CartItemsProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CartItemsRef on AutoDisposeFutureProviderRef<List<CartItem>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _CartItemsProviderElement
    extends AutoDisposeFutureProviderElement<List<CartItem>>
    with CartItemsRef {
  _CartItemsProviderElement(super.provider);

  @override
  String get userId => (origin as CartItemsProvider).userId;
}

String _$userOrdersHash() => r'7fc82d5c5f2efbd0e2995c841615fcd083e0a587';

/// See also [userOrders].
@ProviderFor(userOrders)
const userOrdersProvider = UserOrdersFamily();

/// See also [userOrders].
class UserOrdersFamily extends Family<AsyncValue<List<Order>>> {
  /// See also [userOrders].
  const UserOrdersFamily();

  /// See also [userOrders].
  UserOrdersProvider call(String userId) {
    return UserOrdersProvider(userId);
  }

  @override
  UserOrdersProvider getProviderOverride(
    covariant UserOrdersProvider provider,
  ) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userOrdersProvider';
}

/// See also [userOrders].
class UserOrdersProvider extends AutoDisposeFutureProvider<List<Order>> {
  /// See also [userOrders].
  UserOrdersProvider(String userId)
    : this._internal(
        (ref) => userOrders(ref as UserOrdersRef, userId),
        from: userOrdersProvider,
        name: r'userOrdersProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$userOrdersHash,
        dependencies: UserOrdersFamily._dependencies,
        allTransitiveDependencies: UserOrdersFamily._allTransitiveDependencies,
        userId: userId,
      );

  UserOrdersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<List<Order>> Function(UserOrdersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserOrdersProvider._internal(
        (ref) => create(ref as UserOrdersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Order>> createElement() {
    return _UserOrdersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserOrdersProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserOrdersRef on AutoDisposeFutureProviderRef<List<Order>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserOrdersProviderElement
    extends AutoDisposeFutureProviderElement<List<Order>>
    with UserOrdersRef {
  _UserOrdersProviderElement(super.provider);

  @override
  String get userId => (origin as UserOrdersProvider).userId;
}

String _$orderItemsHash() => r'8fdbab2b0dcef7c17968b5becd4c7c0675358959';

/// See also [orderItems].
@ProviderFor(orderItems)
const orderItemsProvider = OrderItemsFamily();

/// See also [orderItems].
class OrderItemsFamily extends Family<AsyncValue<List<OrderItem>>> {
  /// See also [orderItems].
  const OrderItemsFamily();

  /// See also [orderItems].
  OrderItemsProvider call(String orderId) {
    return OrderItemsProvider(orderId);
  }

  @override
  OrderItemsProvider getProviderOverride(
    covariant OrderItemsProvider provider,
  ) {
    return call(provider.orderId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'orderItemsProvider';
}

/// See also [orderItems].
class OrderItemsProvider extends AutoDisposeFutureProvider<List<OrderItem>> {
  /// See also [orderItems].
  OrderItemsProvider(String orderId)
    : this._internal(
        (ref) => orderItems(ref as OrderItemsRef, orderId),
        from: orderItemsProvider,
        name: r'orderItemsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$orderItemsHash,
        dependencies: OrderItemsFamily._dependencies,
        allTransitiveDependencies: OrderItemsFamily._allTransitiveDependencies,
        orderId: orderId,
      );

  OrderItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderId,
  }) : super.internal();

  final String orderId;

  @override
  Override overrideWith(
    FutureOr<List<OrderItem>> Function(OrderItemsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OrderItemsProvider._internal(
        (ref) => create(ref as OrderItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderId: orderId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<OrderItem>> createElement() {
    return _OrderItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderItemsProvider && other.orderId == orderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OrderItemsRef on AutoDisposeFutureProviderRef<List<OrderItem>> {
  /// The parameter `orderId` of this provider.
  String get orderId;
}

class _OrderItemsProviderElement
    extends AutoDisposeFutureProviderElement<List<OrderItem>>
    with OrderItemsRef {
  _OrderItemsProviderElement(super.provider);

  @override
  String get orderId => (origin as OrderItemsProvider).orderId;
}

String _$cartControllerHash() => r'1929862a0242003f1559ed5fa98faf419fbbfc94';

/// See also [CartController].
@ProviderFor(CartController)
final cartControllerProvider =
    AutoDisposeAsyncNotifierProvider<CartController, void>.internal(
      CartController.new,
      name: r'cartControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$cartControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CartController = AutoDisposeAsyncNotifier<void>;
String _$orderControllerHash() => r'31cf5b0dcaa579854981003296ffb5738aed3b2e';

/// See also [OrderController].
@ProviderFor(OrderController)
final orderControllerProvider =
    AutoDisposeAsyncNotifierProvider<OrderController, void>.internal(
      OrderController.new,
      name: r'orderControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$orderControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OrderController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
