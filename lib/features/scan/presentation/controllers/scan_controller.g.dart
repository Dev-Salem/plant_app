// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recentScansNotifierHash() =>
    r'8710acfd47ce9321c29d38854699bc021bc76437';

/// See also [RecentScansNotifier].
@ProviderFor(RecentScansNotifier)
final recentScansNotifierProvider =
    NotifierProvider<RecentScansNotifier, List<ScanResult>>.internal(
      RecentScansNotifier.new,
      name: r'recentScansNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$recentScansNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RecentScansNotifier = Notifier<List<ScanResult>>;
String _$currentScanNotifierHash() =>
    r'67d103f552aecea47f03f03c1e2e4ef0c654dce8';

/// See also [CurrentScanNotifier].
@ProviderFor(CurrentScanNotifier)
final currentScanNotifierProvider =
    AutoDisposeNotifierProvider<CurrentScanNotifier, ScanResult?>.internal(
      CurrentScanNotifier.new,
      name: r'currentScanNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$currentScanNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentScanNotifier = AutoDisposeNotifier<ScanResult?>;
String _$scanNotifierHash() => r'8becbbcacb1b6190f27faa82554b66c260abcd94';

/// See also [ScanNotifier].
@ProviderFor(ScanNotifier)
final scanNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ScanNotifier, void>.internal(
      ScanNotifier.new,
      name: r'scanNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$scanNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ScanNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
