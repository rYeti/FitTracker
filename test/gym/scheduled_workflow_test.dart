import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:fittnes_tracker/core/app_database.dart';

void main() {
  test('schedule workout and get for date', () async {
    final db = AppDatabase.test(NativeDatabase.memory());

    // Insert a workout template to schedule
    final workoutCompanion = WorkoutTableCompanion.insert(
      name: 'Test Template',
      difficulty: 1,
      estimatedDurationMinutes: const Value(20),
      isTemplate: const Value(true),
    );

    final wId = await db.into(db.workoutTable).insert(workoutCompanion);

    final date = DateTime(2025, 10, 25);
    await db.scheduledWorkoutDao.scheduleWorkout(
      ScheduledWorkoutTableCompanion.insert(
        workoutId: wId,
        scheduledDate: date,
        notes: const Value('unit test'),
      ),
    );

    final items = await db.scheduledWorkoutDao.getForDate(date);
    expect(items, isNotEmpty);
    expect(items.first.workoutId, equals(wId));

    await db.close();
  });
}
