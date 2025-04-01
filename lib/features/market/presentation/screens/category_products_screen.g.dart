// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_products_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryProductsHash() => r'6f2b1cfeea76053f64df58497e75f39c68dfc511';

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

/// See also [categoryProducts].
@ProviderFor(categoryProducts)
const categoryProductsProvider = CategoryProductsFamily();

/// See also [categoryProducts].
class CategoryProductsFamily extends Family<AsyncValue<List<Product>>> {
  /// See also [categoryProducts].
  const CategoryProductsFamily();

  /// See also [categoryProducts].
  CategoryProductsProvider call(String categoryId) {
    return CategoryProductsProvider(categoryId);
  }

  @override
  CategoryProductsProvider getProviderOverride(
    covariant CategoryProductsProvider provider,
  ) {
    return call(provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categoryProductsProvider';
}

/// See also [categoryProducts].
class CategoryProductsProvider
    extends AutoDisposeFutureProvider<List<Product>> {
  /// See also [categoryProducts].
  CategoryProductsProvider(String categoryId)
    : this._internal(
        (ref) => categoryProducts(ref as CategoryProductsRef, categoryId),
        from: categoryProductsProvider,
        name: r'categoryProductsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$categoryProductsHash,
        dependencies: CategoryProductsFamily._dependencies,
        allTransitiveDependencies:
            CategoryProductsFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  CategoryProductsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String categoryId;

  @override
  Override overrideWith(
    FutureOr<List<Product>> Function(CategoryProductsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoryProductsProvider._internal(
        (ref) => create(ref as CategoryProductsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Product>> createElement() {
    return _CategoryProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryProductsProvider && other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoryProductsRef on AutoDisposeFutureProviderRef<List<Product>> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _CategoryProductsProviderElement
    extends AutoDisposeFutureProviderElement<List<Product>>
    with CategoryProductsRef {
  _CategoryProductsProviderElement(super.provider);

  @override
  String get categoryId => (origin as CategoryProductsProvider).categoryId;
}

String _$categoryDetailsHash() => r'c92704c1ec23bf0256e3dd8370896017e1d8d843';

/// See also [categoryDetails].
@ProviderFor(categoryDetails)
const categoryDetailsProvider = CategoryDetailsFamily();

/// See also [categoryDetails].
class CategoryDetailsFamily extends Family<AsyncValue<Category>> {
  /// See also [categoryDetails].
  const CategoryDetailsFamily();

  /// See also [categoryDetails].
  CategoryDetailsProvider call(String categoryId) {
    return CategoryDetailsProvider(categoryId);
  }

  @override
  CategoryDetailsProvider getProviderOverride(
    covariant CategoryDetailsProvider provider,
  ) {
    return call(provider.categoryId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categoryDetailsProvider';
}

/// See also [categoryDetails].
class CategoryDetailsProvider extends AutoDisposeFutureProvider<Category> {
  /// See also [categoryDetails].
  CategoryDetailsProvider(String categoryId)
    : this._internal(
        (ref) => categoryDetails(ref as CategoryDetailsRef, categoryId),
        from: categoryDetailsProvider,
        name: r'categoryDetailsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$categoryDetailsHash,
        dependencies: CategoryDetailsFamily._dependencies,
        allTransitiveDependencies:
            CategoryDetailsFamily._allTransitiveDependencies,
        categoryId: categoryId,
      );

  CategoryDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
  }) : super.internal();

  final String categoryId;

  @override
  Override overrideWith(
    FutureOr<Category> Function(CategoryDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CategoryDetailsProvider._internal(
        (ref) => create(ref as CategoryDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Category> createElement() {
    return _CategoryDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryDetailsProvider && other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoryDetailsRef on AutoDisposeFutureProviderRef<Category> {
  /// The parameter `categoryId` of this provider.
  String get categoryId;
}

class _CategoryDetailsProviderElement
    extends AutoDisposeFutureProviderElement<Category>
    with CategoryDetailsRef {
  _CategoryDetailsProviderElement(super.provider);

  @override
  String get categoryId => (origin as CategoryDetailsProvider).categoryId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
