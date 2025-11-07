import 'package:drift/drift.dart';
import 'app_database_connection.dart'
    if (dart.library.io) 'app_database_connection_native.dart'
    if (dart.library.html) 'app_database_connection_web.dart';

// Import workout planning models
import '../feature/workout_planning/data/models/exercise.dart';
import '../feature/workout_planning/data/models/workout.dart';
import '../feature/workout_planning/data/models/workout_exercise.dart';
import '../feature/workout_planning/data/models/workout_plan.dart';
import '../feature/workout_planning/data/models/workout_set.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    FoodItem,
    UserSettings,
    MealTable,
    MealFoodTable,
    SearchCacheTable,
    WeightRecord,
    // Workout planning tables
    ExerciseTable,
    WorkoutTable,
    WorkoutPlanTable,
    WorkoutExerciseTable,
    WorkoutSetTable,
    WorkoutPlanTable,
    WorkoutPlanWorkoutTable,
    ScheduledWorkoutTable,
  ],
  daos: [
    FoodItemDao,
    UserSettingsDao,
    MealDao,
    SearchCacheDao,
    WeightRecordDao,
    // Workout planning DAOs
    ExerciseDao,
    WorkoutDao,
    WorkoutPlanDao,
    ScheduledWorkoutDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect());

  /// Test constructor that allows providing a custom [QueryExecutor],
  /// useful for in-memory tests.
  AppDatabase.test(QueryExecutor executor) : super(executor);

  // Workout planning DAOs will be added here after code generation

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(userSettings, userSettings.themeMode);
      }
      if (from < 3) {
        await m.createTable(searchCacheTable);
      }
      if (from < 4) {
        // Add newly introduced profile columns to userSettings
        await m.addColumn(userSettings, userSettings.age);
        await m.addColumn(userSettings, userSettings.heightCm);
        await m.addColumn(userSettings, userSettings.sex);
        await m.addColumn(userSettings, userSettings.activityLevel);
        await m.addColumn(userSettings, userSettings.goalType);
      }
      if (from < 5) {
        // Create weight records table
        await m.createTable(weightRecord);
      }
      if (from < 6) {
        // For schema version 6, we add the new weight tracking columns
        // First create the table without attempting to copy data
        await m.addColumn(userSettings, userSettings.startingWeight);
        await m.addColumn(userSettings, userSettings.goalWeight);
      }
      if (from < 7) {
        // For schema version 7, we removed MealTemplates and MealTemplateItems tables
        // These are now handled via SharedPreferences
        try {
          await customStatement('DROP TABLE IF EXISTS meal_template_items');
          await customStatement('DROP TABLE IF EXISTS meal_templates');
          print('Successfully removed meal template tables');
        } catch (e) {
          print('Error removing meal template tables: $e');
          // Continue with migration even if this fails
        }
      }
      if (from < 8) {
        // For schema version 8, we add workout planning tables
        // Create workout planning tables
        await customStatement(
          'CREATE TABLE IF NOT EXISTS exercise_table ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'name TEXT NOT NULL, '
          'description TEXT, '
          'type INTEGER NOT NULL, '
          'target_muscle_groups TEXT NOT NULL, '
          'image_url TEXT, '
          'is_custom BOOLEAN NOT NULL DEFAULT 0'
          ')',
        );

        await customStatement(
          'CREATE TABLE IF NOT EXISTS workout_table ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'name TEXT NOT NULL, '
          'description TEXT, '
          'difficulty INTEGER NOT NULL, '
          'estimated_duration_minutes INTEGER NOT NULL DEFAULT 30, '
          'is_template BOOLEAN NOT NULL DEFAULT 1, '
          'scheduled_date TEXT, '
          'completed_date TEXT'
          ')',
        );

        await customStatement(
          'CREATE TABLE IF NOT EXISTS workout_exercise_table ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'workout_id INTEGER NOT NULL, '
          'exercise_id INTEGER NOT NULL, '
          'order_position INTEGER NOT NULL, '
          'notes TEXT, '
          'FOREIGN KEY (workout_id) REFERENCES workout_table (id), '
          'FOREIGN KEY (exercise_id) REFERENCES exercise_table (id)'
          ')',
        );

        await customStatement(
          'CREATE TABLE IF NOT EXISTS workout_set_table ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'exercise_instance_id INTEGER NOT NULL, '
          'set_number INTEGER NOT NULL, '
          'reps INTEGER, '
          'weight REAL, '
          'weight_unit TEXT, '
          'duration_seconds INTEGER, '
          'is_completed BOOLEAN NOT NULL DEFAULT 0, '
          'notes TEXT, '
          'FOREIGN KEY (exercise_instance_id) REFERENCES workout_exercise_table (id)'
          ')',
        );

        await customStatement(
          'CREATE TABLE IF NOT EXISTS workout_plan_table ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'name TEXT NOT NULL, '
          'description TEXT, '
          'start_date TEXT NOT NULL, '
          'end_date TEXT, '
          'is_active BOOLEAN NOT NULL DEFAULT 1'
          ')',
        );

        await customStatement(
          'CREATE TABLE IF NOT EXISTS workout_plan_workout_table ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'plan_id INTEGER NOT NULL, '
          'workout_id INTEGER NOT NULL, '
          'FOREIGN KEY (plan_id) REFERENCES workout_plan_table (id), '
          'FOREIGN KEY (workout_id) REFERENCES workout_table (id)'
          ')',
        );
      }
      if (from < 9) {
        // Create scheduled workouts table in a safe way (no SQL-side
        // default expressions that sqlite3 native rejects). The table's
        // createdAt column uses a clientDefault instead of a SQL default.
        try {
          await m.createTable(scheduledWorkoutTable);
        } catch (e) {
          print('Error creating scheduled_workout_table during migration: $e');
        }
      }
      if (from < 10) {
        // Create the new WorkoutPlanTable
        await m.createTable(workoutPlanTable);

        // Add workoutPlanId column to existing ScheduledWorkoutTable
        // Add nullable column using raw SQL
        await customStatement(
          'ALTER TABLE scheduled_workout_table ADD COLUMN workout_plan_id INTEGER REFERENCES workout_plan_table(id)',
        );

        // Create a "Legacy Workouts" plan for old data
        await customStatement('''
  INSERT INTO workout_plan_table (name, created_at, is_active, cycle_pattern_json, start_date)
  VALUES ('Legacy Workouts', strftime('%s', 'now'), 0, '[]', strftime('%s', 'now'));
''');

        // Assign all orphaned workouts to this plan
        await customStatement('''
    UPDATE scheduled_workout_table 
    SET workout_plan_id = (SELECT id FROM workout_plan_table WHERE name = 'Legacy Workouts')
    WHERE workout_plan_id IS NULL;
  ''');
      }
    },
  );

  // Workout planning DAOs
  late final exerciseDao = ExerciseDao(this);
  late final workoutDao = WorkoutDao(this);
  late final workoutPlanDao = WorkoutPlanDao(this);
}

@DriftAccessor(tables: [ScheduledWorkoutTable])
class ScheduledWorkoutDao extends DatabaseAccessor<AppDatabase>
    with _$ScheduledWorkoutDaoMixin {
  ScheduledWorkoutDao(AppDatabase db) : super(db);

  Future<List<ScheduledWorkoutTableData>> getForDate(DateTime date) {
    return (select(scheduledWorkoutTable)
      ..where((t) => t.scheduledDate.equals(date))).get();
  }

  Stream<List<ScheduledWorkoutTableData>> watchForDate(DateTime date) {
    return (select(scheduledWorkoutTable)
      ..where((t) => t.scheduledDate.equals(date))).watch();
  }

  Future<int> scheduleWorkout(Insertable<ScheduledWorkoutTableData> item) {
    return into(scheduledWorkoutTable).insert(item);
  }

  Future<int> removeScheduled(int id) {
    return (delete(scheduledWorkoutTable)..where((t) => t.id.equals(id))).go();
  }

  Future<List<ScheduledWorkoutTableData>> getAll() =>
      select(scheduledWorkoutTable).get();

  Future<List<ScheduledWorkoutWithDetails>> getScheduledWithDetailsForDate(
    DateTime date,
  ) async {
    final query = select(scheduledWorkoutTable).join([
      leftOuterJoin(
        workoutTable,
        workoutTable.id.equalsExp(scheduledWorkoutTable.workoutId),
      ),
    ])..where(scheduledWorkoutTable.scheduledDate.equals(date));

    final results = await query.get();

    return results.map((row) {
      return ScheduledWorkoutWithDetails(
        scheduled: row.readTable(scheduledWorkoutTable),
        workout: row.readTableOrNull(workoutTable),
      );
    }).toList();
  }

  Stream<List<ScheduledWorkoutWithDetails>> watchScheduledWithDetailsForDate(
    DateTime date,
  ) {
    // Create a custom stream that watches both scheduled_workout_table and workout_plan_table
    // The readsFrom parameter ensures the stream updates when any of these tables change
    return customSelect(
      '''
      SELECT 
        sw.id as sw_id,
        sw.workout_id,
        sw.scheduled_date,
        sw.is_completed,
        sw.workout_plan_id,
        sw.created_at,
        w.id as w_id,
        w.name as w_name,
        w.description as w_description,
        w.difficulty as w_difficulty,
        w.estimated_duration_minutes,
        w.is_template,
        wp.is_active
      FROM scheduled_workout_table sw
      LEFT JOIN workout_table w ON w.id = sw.workout_id
      LEFT JOIN workout_plan_table wp ON wp.id = sw.workout_plan_id
      WHERE sw.scheduled_date = ?
      ''',
      variables: [Variable.withDateTime(date)],
      readsFrom: {scheduledWorkoutTable, workoutTable, workoutPlanTable},
    ).watch().map((rows) {
      return rows
          .where((row) {
            final isActive = row.readNullable<bool>('is_active');
            return isActive == true;
          })
          .map((row) {
            return ScheduledWorkoutWithDetails(
              scheduled: ScheduledWorkoutTableData(
                id: row.read<int>('sw_id'),
                workoutId: row.read<int>('workout_id'),
                scheduledDate: row.read<DateTime>('scheduled_date'),
                isCompleted: row.read<bool>('is_completed'),
                workoutPlanId: row.readNullable<int>('workout_plan_id'),
                createdAt: row.read<DateTime>('created_at'),
              ),
              workout:
                  row.readNullable<int>('w_id') != null
                      ? WorkoutTableData(
                        id: row.read<int>('w_id'),
                        name: row.read<String>('w_name'),
                        description: row.readNullable<String>('w_description'),
                        isTemplate: row.read<bool>('is_template'),
                        difficulty: row.read<int>('w_difficulty'),
                        estimatedDurationMinutes: row.read<int>(
                          'estimated_duration_minutes',
                        ),
                        scheduledDate: null,
                        completedDate: null,
                      )
                      : null,
            );
          })
          .toList();
    });
  }
}

class ScheduledWorkoutWithDetails {
  final ScheduledWorkoutTableData scheduled;
  final WorkoutTableData? workout;

  ScheduledWorkoutWithDetails({required this.scheduled, this.workout});
}

class FoodItem extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get calories => integer()();
  IntColumn get protein => integer()();
  IntColumn get carbs => integer()();
  IntColumn get fat => integer()();
  IntColumn get gramm => integer().withDefault(const Constant(100))();
}

class UserSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get dailyCalorieGoal =>
      integer().withDefault(const Constant(2000))();
  TextColumn get themeMode => text().withDefault(const Constant('light'))();
  // Profile fields
  IntColumn get age => integer().withDefault(const Constant(30))();
  IntColumn get heightCm => integer().withDefault(const Constant(170))();
  TextColumn get sex => text().withDefault(const Constant('male'))();
  IntColumn get activityLevel => integer().withDefault(const Constant(1))();
  IntColumn get goalType => integer().withDefault(const Constant(1))();
  // Weight tracking fields
  RealColumn get startingWeight => real().withDefault(const Constant(80.0))();
  RealColumn get goalWeight => real().withDefault(const Constant(70.0))();
}

class MealTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  TextColumn get category => text()();
  IntColumn get foodItemId => integer()();
}

class MealFoodTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get mealId => integer().references(MealTable, #id)();
  IntColumn get foodEntryId => integer().references(FoodItem, #id)();
}

// Persistent search cache table
class SearchCacheTable extends Table {
  TextColumn get query => text()();
  TextColumn get json => text()(); // raw json array of products
  IntColumn get ts => integer()(); // epoch millis
  @override
  Set<Column> get primaryKey => {query};
}

class UserTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().unique()();
  TextColumn get email => text().unique()();
  TextColumn get passwordHash => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get profileImageUrl => text().nullable()();
  // Add other user fields as needed
}

@DriftAccessor(tables: [FoodItem])
class FoodItemDao extends DatabaseAccessor<AppDatabase>
    with _$FoodItemDaoMixin {
  FoodItemDao(AppDatabase db) : super(db);

  /// Stream the most recent food items, ordered by id descending, limited by [limit].
  Stream<List<FoodItemData>> watchRecentFoodItems(int limit) {
    return (select(foodItem)
          ..orderBy([
            (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
          ])
          ..limit(limit))
        .watch();
  }

  Future<List<FoodItemData>> getAllFoodItems() => select(foodItem).get();

  Stream<List<FoodItemData>> watchAllFoodItems() => select(foodItem).watch();

  Future<int> insertFoodItem(Insertable<FoodItemData> item) =>
      into(foodItem).insert(item);

  Future<int> deleteFoodItem(Insertable<FoodItemData> item) =>
      delete(foodItem).delete(item);

  Future<FoodItemData?> getFoodItemById(int id) async {
    return (select(foodItem)
      ..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }
}

@DriftAccessor(tables: [UserSettings])
class UserSettingsDao extends DatabaseAccessor<AppDatabase>
    with _$UserSettingsDaoMixin {
  UserSettingsDao(AppDatabase db) : super(db);

  Future<UserSetting?> getSettings() => select(userSettings).getSingleOrNull();

  Future<int> setCalorieGoal(int goal) async {
    final settings = await getSettings();
    if (settings == null) {
      return into(
        userSettings,
      ).insert(UserSettingsCompanion.insert(dailyCalorieGoal: Value(goal)));
    } else {
      final success = await update(
        userSettings,
      ).replace(settings.copyWith(dailyCalorieGoal: goal));
      return success ? 1 : 0;
    }
  }

  // Update profile fields (age, heightCm, sex, activityLevel, goalType)
  Future<int> updateProfile({
    int? age,
    int? heightCm,
    String? sex,
    int? activityLevel,
    int? goalType,
    double? startingWeight,
    double? goalWeight,
  }) async {
    final settings = await getSettings();
    if (settings == null) {
      return into(userSettings).insert(
        UserSettingsCompanion.insert(
          dailyCalorieGoal: const Value(2000),
          age: Value(age ?? 30),
          heightCm: Value(heightCm ?? 170),
          sex: Value(sex ?? 'male'),
          activityLevel: Value(activityLevel ?? 1),
          goalType: Value(goalType ?? 1),
          startingWeight: Value(startingWeight ?? 80.0),
          goalWeight: Value(goalWeight ?? 70.0),
        ),
      );
    } else {
      final updated = settings.copyWith(
        age: age ?? settings.age,
        heightCm: heightCm ?? settings.heightCm,
        sex: sex ?? settings.sex,
        activityLevel: activityLevel ?? settings.activityLevel,
        goalType: goalType ?? settings.goalType,
        startingWeight: startingWeight ?? settings.startingWeight,
        goalWeight: goalWeight ?? settings.goalWeight,
      );
      final success = await update(userSettings).replace(updated);
      return success ? 1 : 0;
    }
  }

  // Update weight goals specifically
  Future<int> updateWeightGoals({
    required double startingWeight,
    required double goalWeight,
  }) async {
    final settings = await getSettings();
    if (settings == null) {
      return into(userSettings).insert(
        UserSettingsCompanion.insert(
          dailyCalorieGoal: const Value(2000),
          startingWeight: Value(startingWeight),
          goalWeight: Value(goalWeight),
        ),
      );
    } else {
      final updated = settings.copyWith(
        startingWeight: startingWeight,
        goalWeight: goalWeight,
      );
      final success = await update(userSettings).replace(updated);
      return success ? 1 : 0;
    }
  }

  Future<void> updateThemeMode(String mode) async {
    final settings = await getSettings();
    if (settings == null) {
      await into(
        userSettings,
      ).insert(UserSettingsCompanion.insert(themeMode: Value(mode)));
    } else {
      await (update(userSettings)..where(
        (tbl) => tbl.id.equals(settings.id),
      )).write(settings.copyWith(themeMode: mode));
    }
  }
}

@DriftAccessor(tables: [MealTable, MealFoodTable, FoodItem])
class MealDao extends DatabaseAccessor<AppDatabase> with _$MealDaoMixin {
  MealDao(AppDatabase db) : super(db);

  Future<List<MealTableData>> getMealsForDate(DateTime date) {
    return (select(mealTable)..where((tbl) => tbl.date.equals(date))).get();
  }

  Future<MealTableData?> getMealById(int id) {
    return (select(mealTable)
      ..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertMeal(Insertable<MealTableData> meal) {
    return into(mealTable).insert(meal);
  }

  Future<int> deleteMeal(Insertable<MealTableData> meal) {
    return delete(mealTable).delete(meal);
  }

  Future<int> addFoodToMeal(int foodId, int mealId) {
    return into(mealFoodTable).insert(
      MealFoodTableCompanion.insert(mealId: mealId, foodEntryId: foodId),
    );
  }

  Future<List<MealFoodTableData>> getFoodItemsForMeal(int mealId) {
    return (select(mealFoodTable)
      ..where((tbl) => tbl.mealId.equals(mealId))).get();
  }

  Future<int> deleteFoodFromMeal(int foodId, int mealId) {
    return (delete(mealFoodTable)..where(
      (tbl) => tbl.mealId.equals(mealId) & tbl.foodEntryId.equals(foodId),
    )).go();
  }
}

@DriftAccessor(tables: [SearchCacheTable])
class SearchCacheDao extends DatabaseAccessor<AppDatabase>
    with _$SearchCacheDaoMixin {
  SearchCacheDao(AppDatabase db) : super(db);

  Future<void> upsert(String q, String jsonData, int ts) async {
    await into(searchCacheTable).insertOnConflictUpdate(
      SearchCacheTableCompanion(
        query: Value(q),
        json: Value(jsonData),
        ts: Value(ts),
      ),
    );
  }

  Future<List<SearchCacheTableData>> getAll() => select(searchCacheTable).get();

  Future<void> deleteByQuery(String q) async {
    await (delete(searchCacheTable)..where((tbl) => tbl.query.equals(q))).go();
  }

  Future<void> deleteOlderThan(int cutoffTs) async {
    await (delete(searchCacheTable)
      ..where((tbl) => tbl.ts.isSmallerThanValue(cutoffTs))).go();
  }
}

// Weight tracking table definition
class WeightRecord extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  RealColumn get weight => real()();
  TextColumn get note => text().nullable()();
}

// Workout planning tables

/// Table for storing exercise definitions
class ExerciseTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get type => integer()(); // Maps to ExerciseType enum index
  TextColumn get targetMuscleGroups => text()();
  TextColumn get imageUrl => text().nullable()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
}

/// Table for storing complete workouts
class WorkoutTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get difficulty =>
      integer()(); // Maps to WorkoutDifficulty enum index
  IntColumn get estimatedDurationMinutes =>
      integer().withDefault(const Constant(30))();
  BoolColumn get isTemplate => boolean().withDefault(const Constant(true))();
  DateTimeColumn get scheduledDate => dateTime().nullable()();
  DateTimeColumn get completedDate => dateTime().nullable()();
}

/// Table for linking exercises to workouts (workout_exercise)
class WorkoutExerciseTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workoutId => integer().references(WorkoutTable, #id)();
  IntColumn get exerciseId => integer().references(ExerciseTable, #id)();
  IntColumn get orderPosition =>
      integer()(); // Order of exercise in workout (renamed from 'order' to avoid SQL keyword conflict)
  TextColumn get notes => text().nullable()();
}

/// Table for storing individual sets within a workout exercise
class WorkoutSetTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get exerciseInstanceId =>
      integer().references(WorkoutExerciseTable, #id)();
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
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  TextColumn get cyclePatternJson => text()();
}

/// Table for linking workouts to plans (many-to-many)
class WorkoutPlanWorkoutTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planId => integer().references(WorkoutPlanTable, #id)();
  IntColumn get workoutId => integer().references(WorkoutTable, #id)();
}

/// Table for storing scheduled workouts (instances of a workout scheduled on a date)
class ScheduledWorkoutTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Links to the workout template or workout entry
  IntColumn get workoutId => integer().references(WorkoutTable, #id)();
  IntColumn get workoutPlanId =>
      integer().nullable().references(WorkoutPlanTable, #id)();

  /// The date/time this workout is scheduled for
  DateTimeColumn get scheduledDate => dateTime()();

  /// When the scheduled entry was created. Use a clientDefault so
  /// sqlite3 native doesn't receive a non-constant SQL default.
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();

  TextColumn get notes => text().nullable()();

  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
}

// Weight tracking DAO
@DriftAccessor(tables: [WeightRecord])
class WeightRecordDao extends DatabaseAccessor<AppDatabase>
    with _$WeightRecordDaoMixin {
  WeightRecordDao(AppDatabase db) : super(db);

  // Get all weight records ordered by date
  Future<List<WeightRecordData>> getAllWeightRecords() =>
      (select(weightRecord)..orderBy([
        (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
      ])).get();

  // Watch all weight records (reactive stream)
  Stream<List<WeightRecordData>> watchAllWeightRecords() =>
      (select(weightRecord)..orderBy([
        (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
      ])).watch();

  // Get the most recent weight record
  Future<WeightRecordData?> getLatestWeightRecord() =>
      (select(weightRecord)
            ..orderBy([
              (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
            ])
            ..limit(1))
          .getSingleOrNull();

  // Add a new weight record
  Future<int> addWeightRecord(Insertable<WeightRecordData> record) =>
      into(weightRecord).insert(record);

  // Update an existing weight record
  Future<bool> updateWeightRecord(Insertable<WeightRecordData> record) =>
      update(weightRecord).replace(record);

  // Delete a weight record
  Future<int> deleteWeightRecord(int id) =>
      (delete(weightRecord)..where((tbl) => tbl.id.equals(id))).go();
}

// Workout planning DAOs

@DriftAccessor(tables: [ExerciseTable])
class ExerciseDao extends DatabaseAccessor<AppDatabase>
    with _$ExerciseDaoMixin {
  ExerciseDao(AppDatabase db) : super(db);

  // Get all exercises
  Future<List<ExerciseTableData>> getAllExercises() =>
      select(exerciseTable).get();

  // Get a specific exercise by ID
  Future<ExerciseTableData?> getExerciseById(int id) =>
      (select(exerciseTable)..where((e) => e.id.equals(id))).getSingleOrNull();

  // Get exercises by type
  Future<List<ExerciseTableData>> getExercisesByType(ExerciseType type) =>
      (select(exerciseTable)..where((e) => e.type.equals(type.index))).get();

  // Insert or update an exercise
  Future<int> saveExercise(ExerciseTableCompanion exercise) =>
      into(exerciseTable).insert(exercise, mode: InsertMode.insertOrReplace);

  // Delete an exercise
  Future<int> deleteExercise(int id) =>
      (delete(exerciseTable)..where((e) => e.id.equals(id))).go();

  // Convert database entity to model
  Exercise entityToModel(ExerciseTableData data) {
    List<MuscleGroup> muscleGroups =
        data.targetMuscleGroups
            .split(',')
            .map((e) => int.parse(e.trim()))
            .map((index) => MuscleGroup.values[index])
            .toList();

    return Exercise(
      id: data.id,
      name: data.name,
      description: data.description,
      type: ExerciseType.values[data.type],
      targetMuscleGroups: muscleGroups,
      imageUrl: data.imageUrl,
      isCustom: data.isCustom,
    );
  }

  // Convert model to database entity companion
  ExerciseTableCompanion modelToEntity(Exercise model) {
    String muscleGroupString = model.targetMuscleGroups
        .map((mg) => mg.index.toString())
        .join(',');

    return ExerciseTableCompanion(
      id: model.id == null ? const Value.absent() : Value(model.id!),
      name: Value(model.name),
      description: Value(model.description),
      type: Value(model.type.index),
      targetMuscleGroups: Value(muscleGroupString),
      imageUrl: Value(model.imageUrl),
      isCustom: Value(model.isCustom),
    );
  }
}

@DriftAccessor(tables: [WorkoutTable, WorkoutExerciseTable, WorkoutSetTable])
class WorkoutDao extends DatabaseAccessor<AppDatabase> with _$WorkoutDaoMixin {
  WorkoutDao(AppDatabase db) : super(db);

  // Get all workouts (templates and scheduled)
  Future<List<WorkoutTableData>> getAllWorkouts() => select(workoutTable).get();

  // Get workout templates only
  Future<List<WorkoutTableData>> getWorkoutTemplates() =>
      (select(workoutTable)..where((w) => w.isTemplate.equals(true))).get();

  // Get scheduled workouts
  Future<List<WorkoutTableData>> getScheduledWorkouts() =>
      (select(workoutTable)..where((w) => w.isTemplate.equals(false))).get();

  // Get scheduled workouts for a date range
  Future<List<WorkoutTableData>> getWorkoutsInDateRange(
    DateTime startDate,
    DateTime endDate,
  ) =>
      (select(workoutTable)
            ..where((w) => w.scheduledDate.isBetweenValues(startDate, endDate))
            ..where((w) => w.isTemplate.equals(false)))
          .get();

  // Get a specific workout with all related data
  Future<Workout?> getCompleteWorkoutById(int id) async {
    final workoutData =
        await (select(workoutTable)
          ..where((w) => w.id.equals(id))).getSingleOrNull();

    if (workoutData == null) return null;

    // Get all exercises for this workout
    final exerciseInstances =
        await (select(workoutExerciseTable)
              ..where((we) => we.workoutId.equals(id))
              ..orderBy([(we) => OrderingTerm.asc(we.orderPosition)]))
            .get();

    final workoutExercises = <WorkoutExercise>[];

    // For each exercise instance, get the exercise details and sets
    for (final exerciseInstance in exerciseInstances) {
      // Get the exercise details
      final exerciseDao = db.exerciseDao;
      final exerciseData = await exerciseDao.getExerciseById(
        exerciseInstance.exerciseId,
      );
      final exercise =
          exerciseData != null ? exerciseDao.entityToModel(exerciseData) : null;

      // Get the sets for this exercise instance
      final sets =
          await (select(workoutSetTable)
                ..where((s) => s.exerciseInstanceId.equals(exerciseInstance.id))
                ..orderBy([(s) => OrderingTerm.asc(s.setNumber)]))
              .get();

      final workoutSets =
          sets
              .map(
                (set) => WorkoutSet(
                  id: set.id,
                  exerciseInstanceId: set.exerciseInstanceId,
                  setNumber: set.setNumber,
                  reps: set.reps,
                  weight: set.weight,
                  weightUnit: set.weightUnit,
                  durationSeconds: set.durationSeconds,
                  isCompleted: set.isCompleted,
                  notes: set.notes,
                ),
              )
              .toList();

      // Create the workout exercise
      workoutExercises.add(
        WorkoutExercise(
          id: exerciseInstance.id,
          workoutId: exerciseInstance.workoutId,
          exerciseId: exerciseInstance.exerciseId,
          orderPosition: exerciseInstance.orderPosition,
          exercise: exercise,
          sets: workoutSets,
          notes: exerciseInstance.notes,
        ),
      );
    }

    // Create and return the complete workout
    return Workout(
      id: workoutData.id,
      name: workoutData.name,
      description: workoutData.description,
      difficulty: WorkoutDifficulty.values[workoutData.difficulty],
      estimatedDurationMinutes: workoutData.estimatedDurationMinutes,
      isTemplate: workoutData.isTemplate,
      scheduledDate: workoutData.scheduledDate,
      completedDate: workoutData.completedDate,
      exercises: workoutExercises,
    );
  }

  // Save a complete workout with exercises and sets
  Future<int> saveCompleteWorkout(Workout workout) async {
    // Start a transaction
    return transaction(() async {
      // 1. Save the workout
      final workoutCompanion = WorkoutTableCompanion(
        id: workout.id == null ? const Value.absent() : Value(workout.id!),
        name: Value(workout.name),
        description: Value(workout.description),
        difficulty: Value(workout.difficulty!.index),
        estimatedDurationMinutes: Value(workout.estimatedDurationMinutes ?? 30),
        isTemplate: Value(workout.isTemplate),
        scheduledDate: Value(workout.scheduledDate),
        completedDate: Value(workout.completedDate),
      );

      final workoutId = await into(
        workoutTable,
      ).insert(workoutCompanion, mode: InsertMode.insertOrReplace);

      // If we're updating an existing workout, delete old exercises and sets
      if (workout.id != null) {
        // Get existing exercise instances
        final existingExercises =
            await (select(workoutExerciseTable)
              ..where((we) => we.workoutId.equals(workout.id!))).get();

        // Delete sets for each exercise instance
        for (final exercise in existingExercises) {
          await (delete(workoutSetTable)
            ..where((s) => s.exerciseInstanceId.equals(exercise.id))).go();
        }

        // Delete exercise instances
        await (delete(workoutExerciseTable)
          ..where((we) => we.workoutId.equals(workout.id!))).go();
      }

      // 2. Save each exercise and its sets
      for (int i = 0; i < workout.exercises.length; i++) {
        final exercise = workout.exercises[i];

        // Save the exercise instance
        final exerciseCompanion = WorkoutExerciseTableCompanion(
          id: exercise.id == null ? const Value.absent() : Value(exercise.id!),
          workoutId: Value(workoutId),
          exerciseId: Value(exercise.exerciseId),
          orderPosition: Value(exercise.orderPosition),
          notes: Value(exercise.notes),
        );

        final exerciseInstanceId = await into(
          workoutExerciseTable,
        ).insert(exerciseCompanion, mode: InsertMode.insertOrReplace);

        // 3. Save each set for this exercise
        for (final set in exercise.sets) {
          final setCompanion = WorkoutSetTableCompanion(
            id: set.id == null ? const Value.absent() : Value(set.id!),
            exerciseInstanceId: Value(exerciseInstanceId),
            setNumber: Value(set.setNumber),
            reps: Value(set.reps),
            weight: Value(set.weight),
            weightUnit: Value(set.weightUnit),
            durationSeconds: Value(set.durationSeconds),
            isCompleted: Value(set.isCompleted),
            notes: Value(set.notes),
          );

          await into(
            workoutSetTable,
          ).insert(setCompanion, mode: InsertMode.insertOrReplace);
        }
      }

      return workoutId;
    });
  }

  // Delete a workout and all related data
  Future<bool> deleteWorkout(int id) {
    return transaction(() async {
      // Get all exercise instances for this workout
      final exerciseInstances =
          await (select(workoutExerciseTable)
            ..where((we) => we.workoutId.equals(id))).get();

      // Delete sets for each exercise instance
      for (final exercise in exerciseInstances) {
        await (delete(workoutSetTable)
          ..where((s) => s.exerciseInstanceId.equals(exercise.id))).go();
      }

      // Delete exercise instances
      await (delete(workoutExerciseTable)
        ..where((we) => we.workoutId.equals(id))).go();

      // Delete workout
      final rowsDeleted =
          await (delete(workoutTable)..where((w) => w.id.equals(id))).go();

      return rowsDeleted > 0;
    });
  }

  Future<WorkoutTableData?> getWorkoutByNameOrNull(String name) {
    return (select(workoutTable)
      ..where((w) => w.name.equals(name))).getSingleOrNull();
  }
}

@DriftAccessor(tables: [WorkoutPlanTable, WorkoutPlanWorkoutTable])
class WorkoutPlanDao extends DatabaseAccessor<AppDatabase>
    with _$WorkoutPlanDaoMixin {
  WorkoutPlanDao(AppDatabase db) : super(db);

  // Get all workout plans
  Future<List<WorkoutPlanTableData>> getAllPlans() =>
      select(workoutPlanTable).get();

  // Get active workout plans
  Future<List<WorkoutPlanTableData>> getActivePlans() =>
      (select(workoutPlanTable)..where((p) => p.isActive.equals(true))).get();

  // Get a specific plan with its workouts
  Future<WorkoutPlan?> getCompletePlanById(int id) async {
    final planData =
        await (select(workoutPlanTable)
          ..where((p) => p.id.equals(id))).getSingleOrNull();

    if (planData == null) return null;

    // Get all workout IDs in this plan
    final workoutLinks =
        await (select(workoutPlanWorkoutTable)
          ..where((link) => link.planId.equals(id))).get();

    final workoutIds = workoutLinks.map((link) => link.workoutId).toList();

    // Get all workouts
    final workouts = <Workout>[];
    final workoutDao = db.workoutDao;

    for (final workoutId in workoutIds) {
      final workout = await workoutDao.getCompleteWorkoutById(workoutId);
      if (workout != null) {
        workouts.add(workout);
      }
    }

    // Create and return the complete plan
    return WorkoutPlan(
      id: planData.id,
      name: planData.name,
      description: planData.description,
      startDate: planData.startDate,
      workouts: workouts,
      isActive: planData.isActive,
    );
  }

  // Save a workout plan with its workouts
  Future<int> saveWorkoutPlan(WorkoutPlan plan) async {
    return transaction(() async {
      // 1. Save the plan
      final planCompanion = WorkoutPlanTableCompanion(
        id: plan.id == null ? const Value.absent() : Value(plan.id!),
        name: Value(plan.name),
        description: Value(plan.description),
        startDate: Value(plan.startDate),
        isActive: Value(plan.isActive),
      );

      final planId = await into(
        workoutPlanTable,
      ).insert(planCompanion, mode: InsertMode.insertOrReplace);

      // If updating, delete old workout links
      if (plan.id != null) {
        await (delete(workoutPlanWorkoutTable)
          ..where((link) => link.planId.equals(plan.id!))).go();
      }

      // 2. Save each workout in the plan
      final workoutDao = db.workoutDao;

      for (final workout in plan.workouts) {
        // Save the workout
        final workoutId = await workoutDao.saveCompleteWorkout(workout);

        // Create link between plan and workout
        await into(workoutPlanWorkoutTable).insert(
          WorkoutPlanWorkoutTableCompanion(
            planId: Value(planId),
            workoutId: Value(workoutId),
          ),
        );
      }

      return planId;
    });
  }

  // Delete a workout plan and unlink its workouts
  Future<bool> deleteWorkoutPlan(int id) {
    return transaction(() async {
      // Delete links to workouts
      await (delete(workoutPlanWorkoutTable)
        ..where((link) => link.planId.equals(id))).go();

      // Delete plan
      final rowsDeleted =
          await (delete(workoutPlanTable)..where((p) => p.id.equals(id))).go();

      return rowsDeleted > 0;
    });
  }
}
