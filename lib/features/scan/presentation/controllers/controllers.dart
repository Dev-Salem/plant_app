import 'package:flutter/cupertino.dart';
import 'package:plant_app/features/scan/data/scan_repository.dart';
import 'package:plant_app/features/scan/domain/entities.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'controllers.g.dart';

@riverpod
class SavedScans extends _$SavedScans {
  @override
  FutureOr<void> build() async {}

  Future<void> saveNewScan(PlantScanResponse scan, VoidCallback onSuccess) async {
    state = const AsyncLoading();
    final repository = ref.read(scanRepositoryProvider);
    state = await AsyncValue.guard(() async {
      await repository.saveAccessToken(scan.accessToken);
    });
    if (!state.hasError) {
      onSuccess();
      ref.invalidate(plantDetectionsProvider);
    }
  }

  Future<void> deleteScan(String token) async {
    state = const AsyncLoading();
    final repository = ref.read(scanRepositoryProvider);
    state = await AsyncValue.guard(() async {
      repository.deleteAccessToken(token);
    });
  }
}
