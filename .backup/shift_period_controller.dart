import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/shift_period_model.dart';
import '../../data/repositories/shift_period_repository.dart';

final shiftPeriodControllerProvider = StateNotifierProvider<ShiftPeriodController, AsyncValue<List<ShiftPeriod>>>((ref) {
  final repository = ref.watch(shiftPeriodRepositoryProvider);
  return ShiftPeriodController(repository);
});

final shiftPeriodRepositoryProvider = Provider<ShiftPeriodRepository>((ref) => ShiftPeriodRepository());

class ShiftPeriodController extends StateNotifier<AsyncValue<List<ShiftPeriod>>> {
  final ShiftPeriodRepository _shiftPeriodRepository;

  ShiftPeriodController(this._shiftPeriodRepository) : super(const AsyncValue.loading()) {
    loadShiftPeriods();
  }

  Future<void> loadShiftPeriods() async {
    try {
      final shiftPeriods = await _shiftPeriodRepository.getAllShiftPeriods();
      state = AsyncValue.data(shiftPeriods);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addShiftPeriod(ShiftPeriod shiftPeriod) async {
    try {
      await _shiftPeriodRepository.createShiftPeriod(shiftPeriod);
      await loadShiftPeriods();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateShiftPeriod(ShiftPeriod shiftPeriod) async {
    try {
      await _shiftPeriodRepository.updateShiftPeriod(shiftPeriod);
      await loadShiftPeriods();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteShiftPeriod(String shiftPeriodId) async {
    try {
      await _shiftPeriodRepository.deleteShiftPeriod(shiftPeriodId);
      await loadShiftPeriods();
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<ShiftPeriod?> getShiftPeriod(String shiftPeriodId) async {
    try {
      return await _shiftPeriodRepository.getShiftPeriod(shiftPeriodId);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  Future<List<ShiftPeriod>> getShiftPeriodsForTeam(String teamId) async {
    try {
      return await _shiftPeriodRepository.getShiftPeriodsForTeam(teamId);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return [];
    }
  }

  Stream<List<ShiftPeriod>> shiftPeriodsStream() {
    return _shiftPeriodRepository.shiftPeriodsStream();
  }
}