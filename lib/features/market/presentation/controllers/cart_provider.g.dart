// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userCartHash() => r'ade058e0aacd64e51fe79fc2705e38d72cbd1c9c';

/// Provider that fetches the current user's cart
///
/// Copied from [userCart].
@ProviderFor(userCart)
final userCartProvider = AutoDisposeFutureProvider<Cart>.internal(
  userCart,
  name: r'userCartProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userCartHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserCartRef = AutoDisposeFutureProviderRef<Cart>;
String _$cartItemCountHash() => r'018501b2b0e31d6ee540bf10895e5a4f9e74bf3f';

/// Provider for the total number of items in the cart
///
/// Copied from [cartItemCount].
@ProviderFor(cartItemCount)
final cartItemCountProvider = AutoDisposeFutureProvider<int>.internal(
  cartItemCount,
  name: r'cartItemCountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cartItemCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CartItemCountRef = AutoDisposeFutureProviderRef<int>;
String _$cartSubtotalHash() => r'd15e065ba7aa84a90d978af9b172ba474b5c45aa';

/// Provider for the cart subtotal
///
/// Copied from [cartSubtotal].
@ProviderFor(cartSubtotal)
final cartSubtotalProvider = AutoDisposeFutureProvider<double>.internal(
  cartSubtotal,
  name: r'cartSubtotalProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cartSubtotalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CartSubtotalRef = AutoDisposeFutureProviderRef<double>;
String _$cartItemByProductIdHash() =>
    r'9562da779de5c4e9be2fe5e1d923fcf559cc4983';

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

/// Provider for getting a specific product from the cart
///
/// Copied from [cartItemByProductId].
@ProviderFor(cartItemByProductId)
const cartItemByProductIdProvider = CartItemByProductIdFamily();

/// Provider for getting a specific product from the cart
///
/// Copied from [cartItemByProductId].
class CartItemByProductIdFamily extends Family<AsyncValue<CartItem?>> {
  /// Provider for getting a specific product from the cart
  ///
  /// Copied from [cartItemByProductId].
  const CartItemByProductIdFamily();

  /// Provider for getting a specific product from the cart
  ///
  /// Copied from [cartItemByProductId].
  CartItemByProductIdProvider call(String productId) {
    return CartItemByProductIdProvider(productId);
  }

  @override
  CartItemByProductIdProvider getProviderOverride(
    covariant CartItemByProductIdProvider provider,
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
  String? get name => r'cartItemByProductIdProvider';
}

/// Provider for getting a specific product from the cart
///
/// Copied from [cartItemByProductId].
class CartItemByProductIdProvider extends AutoDisposeFutureProvider<CartItem?> {
  /// Provider for getting a specific product from the cart
  ///
  /// Copied from [cartItemByProductId].
  CartItemByProductIdProvider(String productId)
    : this._internal(
        (ref) => cartItemByProductId(ref as CartItemByProductIdRef, productId),
        from: cartItemByProductIdProvider,
        name: r'cartItemByProductIdProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$cartItemByProductIdHash,
        dependencies: CartItemByProductIdFamily._dependencies,
        allTransitiveDependencies:
            CartItemByProductIdFamily._allTransitiveDependencies,
        productId: productId,
      );

  CartItemByProductIdProvider._internal(
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
    FutureOr<CartItem?> Function(CartItemByProductIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CartItemByProductIdProvider._internal(
        (ref) => create(ref as CartItemByProductIdRef),
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
  AutoDisposeFutureProviderElement<CartItem?> createElement() {
    return _CartItemByProductIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CartItemByProductIdProvider && other.productId == productId;
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
mixin CartItemByProductIdRef on AutoDisposeFutureProviderRef<CartItem?> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _CartItemByProductIdProviderElement
    extends AutoDisposeFutureProviderElement<CartItem?>
    with CartItemByProductIdRef {
  _CartItemByProductIdProviderElement(super.provider);

  @override
  String get productId => (origin as CartItemByProductIdProvider).productId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
