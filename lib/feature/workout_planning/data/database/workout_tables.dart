import 'package:ForgeForm/core/app_database.dart';
import 'package:drift/drift.dart';

/// Table for storing exercise definitions
class ExerciseTable extends Table {
  // Primary key
  IntColumn get id => integer().autoIncrement()();

  // Basic information
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get type => integer()(); // Maps to ExerciseType enum index

  // We'll store muscle groups as a comma-separated string of indices
  TextColumn get targetMuscleGroups => text()();

  // Additional fields
  TextColumn get imageUrl => text().nullable()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  IntColumn get userId => integer().references(UserTable, #id)();
}

/// Table for storing complete workouts
class WorkoutTable extends Table {
  // Primary key
  IntColumn get id => integer().autoIncrement()();

  // Basic information
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get difficulty =>
      integer()(); // Maps to WorkoutDifficulty enum index
  IntColumn get estimatedDurationMinutes =>
      integer().withDefault(const Constant(30))();

  // Workout status
  BoolColumn get isTemplate => boolean().withDefault(const Constant(true))();
  DateTimeColumn get scheduledDate => dateTime().nullable()();
  DateTimeColumn get completedDate => dateTime().nullable()();
  IntColumn get userId => integer().references(UserTable, #id)();
}

/// Table for linking exercises to workouts (workout_exercise)
class WorkoutExerciseTable extends Table {
  // Primary key
  IntColumn get id => integer().autoIncrement()();

  // Foreign keys
  IntColumn get workoutId => integer().references(WorkoutTable, #id)();
  IntColumn get exerciseId => integer().references(ExerciseTable, #id)();

  // Additional fields
  IntColumn get orderPosition =>
      integer()(); // Order of exercise in workout (renamed from 'order' to avoid SQL keyword)
  TextColumn get notes => text().nullable()();
}

/// Table for storing individual sets within a workout exercise
class WorkoutSetTable extends Table {
  // Primary key
  IntColumn get id => integer().autoIncrement()();

  // Foreign key
  IntColumn get exerciseInstanceId =>
      integer().references(WorkoutExerciseTable, #id)();

  // Set details
  IntColumn get setNumber => integer()();
  IntColumn get reps => integer().nullable()();
  RealColumn get weight => real().nullable()();
  TextColumn get weightUnit => text().nullable()();
  IntColumn get durationSeconds => integer().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
}

/// Table for workout plans/schedules
class WorkoutPlanTable extends Table {
  // Primary key
  IntColumn get id => integer().autoIncrement()();

  // Plan details
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get userId => integer().references(UserTable, #id)();
}

/// Table for linking workouts to plans (many-to-many)
class WorkoutPlanWorkoutTable extends Table {
  // Primary key
  IntColumn get id => integer().autoIncrement()();

  // Foreign keys
  IntColumn get planId => integer().references(WorkoutPlanTable, #id)();
  IntColumn get workoutId => integer().references(WorkoutTable, #id)();
}
