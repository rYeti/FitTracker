import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:fittnes_tracker/core/app_database.dart';
import 'package:fittnes_tracker/core/di/service_locator.dart';
import 'dart:async';

/// Provider that exposes scheduled workouts via the ScheduledWorkoutDao.
class ScheduleWorkoutProvider extends ChangeNotifier {
  final ScheduledWorkoutDao _dao = sl<AppDatabase>().scheduledWorkoutDao;

  StreamSubscription<List<ScheduledWorkoutTableData>>? _subscription;

  DateTime _dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  List<ScheduledWorkoutTableData> _items = [];

  List<ScheduledWorkoutTableData> get scheduled => _items;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  /// Load scheduled items for the given date (exact match)
  Future<void> loadForDate(DateTime date) async {
    _subscribeToDate(date);
  }

  Stream<List<ScheduledWorkoutTableData>> watchForDate(DateTime date) {
    return _dao.watchForDate(date);
  }

  /// Schedule a workout and refresh the cached list for that date.
  Future<int> scheduleWorkout({
    required int workoutId,
    required DateTime scheduledDate,
    String? notes,
  }) async {
    final companion = ScheduledWorkoutTableCompanion(
      workoutId: Value(workoutId),
      scheduledDate: Value(scheduledDate),
      notes: Value(notes),
    );

    final id = await _dao.scheduleWorkout(companion);
    await loadForDate(scheduledDate);
    return id;
  }

  Future<int> removeScheduled(int id, DateTime forDate) async {
    final res = await _dao.removeScheduled(id);
    await loadForDate(forDate);
    return res;
  }

  void _subscribeToDate(DateTime date) {
    _subscription?.cancel();
    final normalizedDate = _dateOnly(date);
    _subscription = _dao.watchForDate(normalizedDate).listen((items) {
      _items = items;
      notifyListeners();
    });
  }
}
