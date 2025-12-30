import 'package:ForgeForm/core/app_database.dart';
import 'package:ForgeForm/core/di/service_locator.dart';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'dart:async';

/// Provider that exposes scheduled workouts via the ScheduledWorkoutDao.
class ScheduleWorkoutProvider extends ChangeNotifier {
  final ScheduledWorkoutDao _dao = sl<AppDatabase>().scheduledWorkoutDao;

  StreamSubscription<List<ScheduledWorkoutWithDetails>>? _subscription;
  DateTime? _currentDate;
  bool _isRefreshing = false;

  DateTime _dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  List<ScheduledWorkoutWithDetails> _items = [];

  List<ScheduledWorkoutWithDetails> get scheduled => _items;
  bool get isRefreshing => _isRefreshing;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  /// Load scheduled items for the given date (exact match)
  Future<void> loadForDate(DateTime date) async {
    _subscribeToDate(date);
  }

  /// Refresh the current subscription (useful after creating/editing workouts)
  void refresh() {
    // Set refreshing flag and clear items immediately
    _isRefreshing = true;
    _items = [];
    notifyListeners();
    // Cancel and re-subscribe to force a refresh
    if (_currentDate != null) {
      _subscribeToDate(_currentDate!);
    }
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
    _items = []; // Clear immediately before subscribing
    final normalizedDate = _dateOnly(date);
    _currentDate = normalizedDate; // Track the current date
    _subscription = _dao.watchScheduledWithDetailsForDate(normalizedDate).listen((
      items,
    ) {
      // Debug: log incoming scheduled items and whether a workout was resolved
      try {
        // Lightweight logging for troubleshooting in development
        if (items.isEmpty) {
          if (kDebugMode)
            print('ScheduledWorkoutProvider: no items for $normalizedDate');
        } else {
          if (kDebugMode)
            print(
              'ScheduledWorkoutProvider: received ${items.length} items for $normalizedDate',
            );
          for (final it in items) {
            final s = it.scheduled;
            final w = it.workout;
            if (kDebugMode)
              print(
                '  sw.id=${s.id} workoutId=${s.workoutId} templateId=${s.templateWorkoutId} -> workout.name=${w?.name}',
              );
          }
        }
      } catch (e) {
        if (kDebugMode) print('ScheduledWorkoutProvider: logging failed: $e');
      }

      // Filter scheduled items by the currently active plan (if any).
      try {
        final db = sl<AppDatabase>();
        db.workoutPlanDao
            .getActivePlans()
            .then((activePlans) {
              final activePlanId =
                  activePlans.isNotEmpty ? activePlans.first.id : null;
              if (kDebugMode)
                print('ScheduledWorkoutProvider: activePlanId = $activePlanId');

              if (activePlanId != null) {
                _items =
                    items
                        .where(
                          (it) => it.scheduled.workoutPlanId == activePlanId,
                        )
                        .toList();
              } else {
                // No active plan defined — show all scheduled items
                _items = List.from(items);
              }

              _isRefreshing = false; // Clear refreshing flag when data arrives
              notifyListeners();
            })
            .catchError((e) {
              if (kDebugMode)
                print(
                  'ScheduledWorkoutProvider: failed to query active plan: $e',
                );
              _items = List.from(items);
              _isRefreshing = false;
              notifyListeners();
            });
        return;
      } catch (e) {
        if (kDebugMode) print('ScheduledWorkoutProvider: filter error: $e');
        _items = List.from(items);
        _isRefreshing = false;
        notifyListeners();
        return;
      }
    });
  }
}
