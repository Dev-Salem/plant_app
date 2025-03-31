import 'package:flutter/cupertino.dart';
import 'package:plant_app/features/scan/data/scan_repository.dart';
import 'package:plant_app/features/scan/domain/entities.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'controllers.g.dart';

@riverpod
class SavedScans extends _$SavedScans {
  @override
  FutureOr<List<String>> build() async {
    return [];
  }

  Future<void> saveNewScan(PlantScanResponse scan, VoidCallback onSuccess) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(scanRepositoryProvider);
      await repository.saveAccessToken(scan.accessToken);
      state = AsyncData([...?state.value, scan.accessToken]);
      onSuccess();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteScan(String token) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(scanRepositoryProvider);
      await repository.deleteAccessToken(token);
      state = AsyncData(state.value?.where((t) => t != token).toList() ?? []);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
