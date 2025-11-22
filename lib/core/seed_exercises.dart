import 'package:ForgeForm/core/app_database.dart';
import 'package:ForgeForm/feature/workout_planning/data/models/exercise.dart';

/// Seeds the database with common exercises if none exist
Future<void> seedExercisesIfEmpty(AppDatabase db) async {
  final existingExercises = await db.exerciseDao.getAllExercises();

  if (existingExercises.isNotEmpty) {
    return; // Already have exercises, don't seed
  }

  final exercises = [
    // Chest exercises
    Exercise(
      name: 'Bench Press',
      description: 'Barbell bench press for chest development',
      type: ExerciseType.strength,
      targetMuscleGroups: [MuscleGroup.chest, MuscleGroup.triceps],
    ),
    Exercise(
      name: 'Incline Dumbbell Press',
      description: 'Upper chest focus with dumbbells',
      type: ExerciseType.strength,
      targetMuscleGroups: [MuscleGroup.chest, MuscleGroup.shoulders],
    ),
    Exercise(
      name: 'Push-Ups',
      description: 'Classic bodyweight chest exercise',
      type: ExerciseType.calisthenics,
      targetMuscleGroups: [MuscleGroup.chest, MuscleGroup.triceps],
    ),
    Exercise(
      name: 'Cable Flyes',
      description: 'Isolation exercise for chest',
      type: ExerciseType.strength,
      targetMuscleGroups: [MuscleGroup.chest],
    ),

    // Back exercises
    Exercise(
      name: 'Deadlift',
      description: 'Compound movement for overall back development',
      type: ExerciseType.strength,
      targetMuscleGroups: [MuscleGroup.back, MuscleGroup.legs],
    ),
    Exercise(
      name: 'Pull-Ups',
      description: 'Bodyweight exercise for lats',
      type: ExerciseType.calisthenics,
      targetMuscleGroups: [MuscleGroup.back, MuscleGroup.biceps],
    ),
    Exercise(
      name: 'Barbell Row',
      description: 'Heavy compound movement for back thickness',
      type: ExerciseType.strength,
      targetMuscleGroups: [MuscleGroup.back],
    ),
    Exercise(
      name: 'Lat Pulldown',
      description: 'Machine exercise for lat width',
      type: ExerciseType.strength,
      targetMuscleGroups: [MuscleGroup.back],
    ),

    // Shoulder exercises
    Exercise(
      name: 'Overhead Press',
      description: 'Barbell or dumbbell press for shoulders',
      type: ExerciseType.strength,
      targetMuscleGroups: [MuscleGroup.shoulders, MuscleGroup.triceps],
    ),
    Exercise(
      name: 'Lateral Raises',
      description: 'Isolation for side delts',
      type: ExerciseType.strength,
      targetMuscleGroups: [MuscleGroup.shoulders],
    ),
    Exercise(
      name: 'Face Pulls',
      description: 'Rear delt and upper back exercise',
      type: ExerciseType.strength,
      targetMuscleGroups: [MuscleGroup.shoulders, MuscleGroup.back],
    ),

    // Arm exercises
    Exercise(
      name: 'Barbell Curl',
      description: 'Classic bicep builder',
      type: ExerciseType.strength,
      targetMuscleGroups: [MuscleGroup.biceps],
    ),
    Exercise(
      name: 'Hammer Curls',
      description: 'Targets biceps and forearms',
      type: ExerciseType.strength,
      targetMuscleGroups: [MuscleGroup.biceps],
    ),
    Exercise(
      name: 'Tricep Dips',
      description: 'Bodyweight exercise for triceps',
      type: ExerciseType.calisthenics,
      targetMuscleGroups: [MuscleGroup.triceps],
    ),
    Exercise(
      name: 'Skull Crushers',
      description: 'Lying tricep extension',
      type: ExerciseType.strength,
      targetMuscleGroups: [MuscleGroup.triceps],
    ),

    // Leg exercises
    Exercise(
      name: 'Squat',
      description: 'King of leg exercises',
      type: ExerciseType.strength,
      targetMuscleGroups: [MuscleGroup.legs],
    ),
    Exercise(
      name: 'Leg Press',
      description: 'Machine-based quad and glute builder',
      type: ExerciseType.strength,
      targetMuscleGroups: [MuscleGroup.legs],
    ),
    Exercise(
      name: 'Romanian Deadlift',
      description: 'Hamstring and glute focus',
      type: ExerciseType.strength,
      targetMuscleGroups: [MuscleGroup.legs, MuscleGroup.back],
    ),
    Exercise(
      name: 'Leg Curls',
      description: 'Isolation for hamstrings',
      type: ExerciseType.strength,
      targetMuscleGroups: [MuscleGroup.legs],
    ),
    Exercise(
      name: 'Calf Raises',
      description: 'Standing or seated calf development',
      type: ExerciseType.strength,
      targetMuscleGroups: [MuscleGroup.legs],
    ),

    // Ab exercises
    Exercise(
      name: 'Plank',
      description: 'Isometric core exercise',
      type: ExerciseType.calisthenics,
      targetMuscleGroups: [MuscleGroup.abs],
    ),
    Exercise(
      name: 'Crunches',
      description: 'Basic ab exercise',
      type: ExerciseType.calisthenics,
      targetMuscleGroups: [MuscleGroup.abs],
    ),
    Exercise(
      name: 'Hanging Leg Raises',
      description: 'Advanced ab exercise',
      type: ExerciseType.calisthenics,
      targetMuscleGroups: [MuscleGroup.abs],
    ),
    Exercise(
      name: 'Russian Twists',
      description: 'Oblique targeting exercise',
      type: ExerciseType.calisthenics,
      targetMuscleGroups: [MuscleGroup.abs],
    ),

    // Full body / Cardio
    Exercise(
      name: 'Burpees',
      description: 'Full body conditioning exercise',
      type: ExerciseType.calisthenics,
      targetMuscleGroups: [MuscleGroup.fullBody],
    ),
    Exercise(
      name: 'Running',
      description: 'Cardio exercise',
      type: ExerciseType.cardio,
      targetMuscleGroups: [MuscleGroup.legs],
    ),
    Exercise(
      name: 'Jump Rope',
      description: 'Cardio and coordination',
      type: ExerciseType.cardio,
      targetMuscleGroups: [MuscleGroup.fullBody],
    ),
  ];

  // Insert all exercises
  for (final exercise in exercises) {
    await db.exerciseDao.saveExercise(db.exerciseDao.modelToEntity(exercise));
  }
}
