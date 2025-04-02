// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminOrdersHash() => r'e8e44fec238571bf82ae7d8733f749cb064a9f2d';

/// See also [adminOrders].
@ProviderFor(adminOrders)
final adminOrdersProvider = AutoDisposeFutureProvider<List<Order>>.internal(
  adminOrders,
  name: r'adminOrdersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$adminOrdersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminOrdersRef = AutoDisposeFutureProviderRef<List<Order>>;
String _$adminOrderDetailsHash() => r'09b7f142537dd1ccfd3a369853783289b4e8ebac';

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

/// See also [adminOrderDetails].
@ProviderFor(adminOrderDetails)
const adminOrderDetailsProvider = AdminOrderDetailsFamily();

/// See also [adminOrderDetails].
class AdminOrderDetailsFamily extends Family<AsyncValue<Order>> {
  /// See also [adminOrderDetails].
  const AdminOrderDetailsFamily();

  /// See also [adminOrderDetails].
  AdminOrderDetailsProvider call(String orderId) {
    return AdminOrderDetailsProvider(orderId);
  }

  @override
  AdminOrderDetailsProvider getProviderOverride(
    covariant AdminOrderDetailsProvider provider,
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
  String? get name => r'adminOrderDetailsProvider';
}

/// See also [adminOrderDetails].
class AdminOrderDetailsProvider extends AutoDisposeFutureProvider<Order> {
  /// See also [adminOrderDetails].
  AdminOrderDetailsProvider(String orderId)
    : this._internal(
        (ref) => adminOrderDetails(ref as AdminOrderDetailsRef, orderId),
        from: adminOrderDetailsProvider,
        name: r'adminOrderDetailsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$adminOrderDetailsHash,
        dependencies: AdminOrderDetailsFamily._dependencies,
        allTransitiveDependencies:
            AdminOrderDetailsFamily._allTransitiveDependencies,
        orderId: orderId,
      );

  AdminOrderDetailsProvider._internal(
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
    FutureOr<Order> Function(AdminOrderDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AdminOrderDetailsProvider._internal(
        (ref) => create(ref as AdminOrderDetailsRef),
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
  AutoDisposeFutureProviderElement<Order> createElement() {
    return _AdminOrderDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminOrderDetailsProvider && other.orderId == orderId;
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
mixin AdminOrderDetailsRef on AutoDisposeFutureProviderRef<Order> {
  /// The parameter `orderId` of this provider.
  String get orderId;
}

class _AdminOrderDetailsProviderElement
    extends AutoDisposeFutureProviderElement<Order>
    with AdminOrderDetailsRef {
  _AdminOrderDetailsProviderElement(super.provider);

  @override
  String get orderId => (origin as AdminOrderDetailsProvider).orderId;
}

String _$adminOrderItemsHash() => r'd0dd151610236235cbb4242611dff62a00a9de87';

/// See also [adminOrderItems].
@ProviderFor(adminOrderItems)
const adminOrderItemsProvider = AdminOrderItemsFamily();

/// See also [adminOrderItems].
class AdminOrderItemsFamily extends Family<AsyncValue<List<OrderItem>>> {
  /// See also [adminOrderItems].
  const AdminOrderItemsFamily();

  /// See also [adminOrderItems].
  AdminOrderItemsProvider call(String orderId) {
    return AdminOrderItemsProvider(orderId);
  }

  @override
  AdminOrderItemsProvider getProviderOverride(
    covariant AdminOrderItemsProvider provider,
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
  String? get name => r'adminOrderItemsProvider';
}

/// See also [adminOrderItems].
class AdminOrderItemsProvider
    extends AutoDisposeFutureProvider<List<OrderItem>> {
  /// See also [adminOrderItems].
  AdminOrderItemsProvider(String orderId)
    : this._internal(
        (ref) => adminOrderItems(ref as AdminOrderItemsRef, orderId),
        from: adminOrderItemsProvider,
        name: r'adminOrderItemsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$adminOrderItemsHash,
        dependencies: AdminOrderItemsFamily._dependencies,
        allTransitiveDependencies:
            AdminOrderItemsFamily._allTransitiveDependencies,
        orderId: orderId,
      );

  AdminOrderItemsProvider._internal(
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
    FutureOr<List<OrderItem>> Function(AdminOrderItemsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AdminOrderItemsProvider._internal(
        (ref) => create(ref as AdminOrderItemsRef),
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
    return _AdminOrderItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AdminOrderItemsProvider && other.orderId == orderId;
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
mixin AdminOrderItemsRef on AutoDisposeFutureProviderRef<List<OrderItem>> {
  /// The parameter `orderId` of this provider.
  String get orderId;
}

class _AdminOrderItemsProviderElement
    extends AutoDisposeFutureProviderElement<List<OrderItem>>
    with AdminOrderItemsRef {
  _AdminOrderItemsProviderElement(super.provider);

  @override
  String get orderId => (origin as AdminOrderItemsProvider).orderId;
}

String _$addProductNotifierHash() =>
    r'5a911d84dc6f7281ba280656bc733d8cf1201f04';

/// See also [AddProductNotifier].
@ProviderFor(AddProductNotifier)
final addProductNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AddProductNotifier, void>.internal(
      AddProductNotifier.new,
      name: r'addProductNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$addProductNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AddProductNotifier = AutoDisposeAsyncNotifier<void>;
String _$updateProductNotifierHash() =>
    r'51b1153e38ecc93fedf293f4df4dff6e3c250b96';

/// See also [UpdateProductNotifier].
@ProviderFor(UpdateProductNotifier)
final updateProductNotifierProvider =
    AutoDisposeAsyncNotifierProvider<UpdateProductNotifier, void>.internal(
      UpdateProductNotifier.new,
      name: r'updateProductNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$updateProductNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UpdateProductNotifier = AutoDisposeAsyncNotifier<void>;
String _$deleteProductNotifierHash() =>
    r'e3c4c76a17250383e1b72a1ed8a19922f2ca9143';

/// See also [DeleteProductNotifier].
@ProviderFor(DeleteProductNotifier)
final deleteProductNotifierProvider =
    AutoDisposeAsyncNotifierProvider<DeleteProductNotifier, void>.internal(
      DeleteProductNotifier.new,
      name: r'deleteProductNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$deleteProductNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DeleteProductNotifier = AutoDisposeAsyncNotifier<void>;
String _$updateOrderStatusNotifierHash() =>
    r'3c7b987fdbbeb2b7d8c6f96a7886736ed478e74e';

/// See also [UpdateOrderStatusNotifier].
@ProviderFor(UpdateOrderStatusNotifier)
final updateOrderStatusNotifierProvider =
    AutoDisposeAsyncNotifierProvider<UpdateOrderStatusNotifier, void>.internal(
      UpdateOrderStatusNotifier.new,
      name: r'updateOrderStatusNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$updateOrderStatusNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UpdateOrderStatusNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
