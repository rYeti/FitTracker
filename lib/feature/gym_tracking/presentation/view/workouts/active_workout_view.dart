import 'package:ForgeForm/core/app_database.dart';
import 'package:ForgeForm/feature/gym_tracking/presentation/widgets/reset_timer_widget.dart';
import 'package:ForgeForm/l10n/app_localizations.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/reset_timer_widget.dart';

/// Completely fixed version addressing all 6 reported issues
class ActiveWorkoutScreen extends StatefulWidget {
  final ScheduledWorkoutWithDetails scheduledWorkout;
  final DateTime scheduledDate;
  final bool isReadOnly;
  const ActiveWorkoutScreen({
    super.key,
    required this.scheduledWorkout,
    required this.scheduledDate,
    this.isReadOnly = false,
  });
  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  int _currentExerciseIndex = 0;
  int _currentSetIndex = 0;
  bool _isLoading = true;
  bool _isSaving = false;
  final TextEditingController _workoutNoteController = TextEditingController();
  // FIX #1 & #2: Store controllers by UNIQUE composite key
  // Key format: "scheduledWorkoutId_workoutExerciseId"
  final Map<String, TextEditingController> _exerciseNoteControllers = {};
  // FIX #1: Store set controllers by UNIQUE composite key
  // Key format: "scheduledWorkoutId_workoutExerciseId_setNumber_field"
  final Map<String, TextEditingController> _setControllers = {};
  List<_ExerciseWithSets> _exercises = [];
  @override
  void initState() {
    super.initState();
    _loadWorkoutData();
  }

  @override
  void dispose() {
    _workoutNoteController.dispose();
    _exerciseNoteControllers.values.forEach((c) => c.dispose());
    _setControllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  /// FIX #1 & #2: Generate unique key for exercise notes
  String _getExerciseNoteKey(int workoutExerciseId) {
    final scheduledId = widget.scheduledWorkout.scheduled?.id;

    if (scheduledId == null) {
      throw StateError('Scheduled workout ID is null');
    }

    return '${scheduledId}_$workoutExerciseId';
  }

  /// FIX #1: Generate unique key for set controllers
  String _getSetControllerKey(
    int workoutExerciseId,
    int setNumber,
    String field,
  ) {
    final scheduledId = widget.scheduledWorkout.scheduled?.id;

    if (scheduledId == null) {
      throw StateError('Scheduled workout ID is null');
    }

    return '${scheduledId}_${workoutExerciseId}_${setNumber}_$field';
  }

  Future<void> _loadWorkoutData() async {
    print('=== LOADING WORKOUT DATA ===');
    print('Scheduled Workout ID: ${widget.scheduledWorkout.scheduled.id}');
    print(
      'Template Workout ID: ${widget.scheduledWorkout.scheduled.templateWorkoutId}',
    );
    print('Scheduled Date: ${widget.scheduledDate}');
    setState(() => _isLoading = true);

    try {
      final db = context.read<AppDatabase>();
      final workout = widget.scheduledWorkout.workout;

      if (workout == null) {
        throw Exception('Workout not found');
      }

      // Load workout note for THIS SPECIFIC DATE
      final scheduledWorkoutData =
          await (db.select(db.scheduledWorkoutTable)..where(
            (t) => t.id.equals(widget.scheduledWorkout.scheduled.id),
          )).getSingle(); // Use getSingle since we know it exists

      if (scheduledWorkoutData.notes != null) {
        _workoutNoteController.text = scheduledWorkoutData.notes!;
      }

      // Load exercises with templates
      final exercisesData = await db.workoutDao
          .getWorkoutExercisesWithTemplates(workout.id);

      print('Found ${exercisesData.length} exercises in template');

      // FIX #3: Handle empty exercises gracefully
      if (exercisesData.isEmpty) {
        print('WARNING: No exercises found for workout ${workout.name}');
        setState(() {
          _exercises = [];
          _isLoading = false;
        });
        return;
      }

      final exercises = <_ExerciseWithSets>[];

      for (final exerciseData in exercisesData) {
        final exercise = exerciseData.$1;
        final templates = exerciseData.$2;
        final workoutExercise = exerciseData.$3;

        print(
          'Processing exercise: ${exercise.name} (workoutExerciseId: ${workoutExercise.id})',
        );

        // FIX #6: Load previous sets from most recent COMPLETED workout
        final previousSets = await _loadPreviousWorkoutSets(
          db: db,
          workoutExerciseId: workoutExercise.id,
        );

        print(
          'Found ${previousSets.length} previous sets for ${exercise.name}',
        );

        final previousSetsMap = {
          for (var set in previousSets) set.setNumber: set,
        };

        // FIX #2 & #4: Load exercise note ONLY for this specific scheduled workout
        // Use getSingleOrNull to avoid "too many elements" error
        final scheduledExercise =
            await (db.select(db.scheduledWorkoutExerciseTable)
                  ..where((t) => t.workoutExerciseId.equals(workoutExercise.id))
                  ..where(
                    (t) => t.scheduledWorkoutId.equals(
                      widget.scheduledWorkout.scheduled.id,
                    ),
                  ))
                .getSingleOrNull();

        print(
          'Scheduled exercise exists: ${scheduledExercise != null}, notes: ${scheduledExercise?.notes}',
        );

        // FIX #2: Use unique key for exercise notes
        final exerciseNoteKey = _getExerciseNoteKey(workoutExercise.id);
        final noteController = TextEditingController(
          text: scheduledExercise?.notes ?? '',
        );
        _exerciseNoteControllers[exerciseNoteKey] = noteController;

        // FIX #5: Load existing set data for THIS DATE
        final existingSets =
            scheduledExercise != null
                ? await (db.select(db.workoutSetTable)
                      ..where(
                        (t) => t.scheduledWorkoutExerciseId.equals(
                          scheduledExercise.id,
                        ),
                      )
                      ..orderBy([(t) => OrderingTerm.asc(t.setNumber)]))
                    .get()
                : <WorkoutSetTableData>[];

        print('Found ${existingSets.length} existing sets for this date');

        final existingSetsMap = {
          for (var set in existingSets) set.setNumber: set,
        };

        // FIX #1 & #5: Initialize controllers with unique keys
        for (final template in templates) {
          final existingSet = existingSetsMap[template.setNumber];

          final weightKey = _getSetControllerKey(
            workoutExercise.id,
            template.setNumber,
            'weight',
          );
          final repsKey = _getSetControllerKey(
            workoutExercise.id,
            template.setNumber,
            'reps',
          );

          // FIX #5: Load existing data if available
          _setControllers[weightKey] = TextEditingController(
            text: existingSet?.weight?.toStringAsFixed(1) ?? '',
          );

          _setControllers[repsKey] = TextEditingController(
            text: existingSet?.reps?.toString() ?? '',
          );

          print(
            'Set ${template.setNumber}: weight=${existingSet?.weight}, reps=${existingSet?.reps}',
          );
        }

        exercises.add(
          _ExerciseWithSets(
            exercise: exercise,
            workoutExercise: workoutExercise,
            templates: templates,
            previousSets: previousSetsMap,
            scheduledExerciseId: scheduledExercise?.id,
          ),
        );
      }

      setState(() {
        _exercises = exercises;
        _isLoading = false;
      });

      print('=== WORKOUT DATA LOADED SUCCESSFULLY ===');
    } catch (e, stackTrace) {
      print('ERROR loading workout data: $e');
      print('Stack trace: $stackTrace');

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading workout: $e')));
      }
      setState(() => _isLoading = false);
    }
  }

  /// FIX #6: Load previous workout sets from the most recent COMPLETED workout
  Future<List<WorkoutSetTableData>> _loadPreviousWorkoutSets({
    required AppDatabase db,
    required int workoutExerciseId,
  }) async {
    try {
      print(
        'Looking for previous sets for workoutExerciseId: $workoutExerciseId',
      );
      // Find all previous scheduled workouts for the same template that are completed
      final previousScheduledWorkouts =
          await (db.select(db.scheduledWorkoutTable)
                ..where(
                  (t) => t.templateWorkoutId.equals(
                    widget.scheduledWorkout.scheduled.templateWorkoutId!,
                  ),
                )
                ..where(
                  (t) => t.id.isNotValue(widget.scheduledWorkout.scheduled.id),
                )
                ..where((t) => t.isCompleted.equals(true))
                ..where(
                  (t) =>
                      t.scheduledDate.isSmallerThanValue(widget.scheduledDate),
                )
                ..orderBy([(t) => OrderingTerm.desc(t.scheduledDate)]))
              .get();

      print(
        'Found ${previousScheduledWorkouts.length} previous completed workouts',
      );

      if (previousScheduledWorkouts.isEmpty) {
        return [];
      }

      // Get the most recent one
      final mostRecentWorkout = previousScheduledWorkouts.first;
      print('Most recent workout date: ${mostRecentWorkout.scheduledDate}');

      // Find the corresponding scheduled exercise
      final previousScheduledExercise =
          await (db.select(db.scheduledWorkoutExerciseTable)
                ..where(
                  (t) => t.scheduledWorkoutId.equals(mostRecentWorkout.id),
                )
                ..where((t) => t.workoutExerciseId.equals(workoutExerciseId)))
              .getSingleOrNull();

      if (previousScheduledExercise == null) {
        print('No matching exercise found in previous workout');
        return [];
      }

      print(
        'Found previous scheduled exercise: ${previousScheduledExercise.id}',
      );

      // Get the sets
      final sets =
          await (db.select(db.workoutSetTable)
                ..where(
                  (t) => t.scheduledWorkoutExerciseId.equals(
                    previousScheduledExercise.id,
                  ),
                )
                ..orderBy([(t) => OrderingTerm.asc(t.setNumber)]))
              .get();

      print('Found ${sets.length} sets from previous workout');

      return sets;
    } catch (e) {
      print('Error loading previous sets: $e');
      return [];
    }
  }

  TextEditingController _getController(
    int workoutExerciseId,
    int setNumber,
    String field,
  ) {
    final key = _getSetControllerKey(workoutExerciseId, setNumber, field);
    final controller = _setControllers[key];
    if (controller == null) {
      print('WARNING: Controller not found for key: $key');
      return TextEditingController(); // Return empty controller as fallback
    }

    return controller;
  }

  Future<void> _saveCurrentExercise() async {
    if (_currentExerciseIndex >= _exercises.length) return;
    if (widget.isReadOnly) return;
    final db = context.read<AppDatabase>();
    final exerciseData = _exercises[_currentExerciseIndex];

    try {
      print('Saving exercise: ${exerciseData.exercise.name}');

      // FIX #2: Get note controller using unique key
      final exerciseNoteKey = _getExerciseNoteKey(
        exerciseData.workoutExercise.id,
      );
      final noteController = _exerciseNoteControllers[exerciseNoteKey];

      if (noteController == null) {
        print('WARNING: Note controller not found for key: $exerciseNoteKey');
      }

      int scheduledExerciseId;

      if (exerciseData.scheduledExerciseId != null) {
        scheduledExerciseId = exerciseData.scheduledExerciseId!;

        // Update existing
        await (db.update(db.scheduledWorkoutExerciseTable)
          ..where((t) => t.id.equals(scheduledExerciseId))).write(
          ScheduledWorkoutExerciseTableCompanion(
            notes: Value(
              noteController?.text.isEmpty ?? true
                  ? null
                  : noteController!.text,
            ),
          ),
        );

        print('Updated existing scheduled exercise: $scheduledExerciseId');
      } else {
        // Create new
        scheduledExerciseId = await db
            .into(db.scheduledWorkoutExerciseTable)
            .insert(
              ScheduledWorkoutExerciseTableCompanion.insert(
                scheduledWorkoutId: widget.scheduledWorkout.scheduled.id,
                workoutExerciseId: exerciseData.workoutExercise.id,
                notes: Value(
                  noteController?.text.isEmpty ?? true
                      ? null
                      : noteController!.text,
                ),
              ),
            );

        exerciseData.scheduledExerciseId = scheduledExerciseId;
        print('Created new scheduled exercise: $scheduledExerciseId');
      }

      // Delete existing sets for this exercise
      await (db.delete(db.workoutSetTable)..where(
        (t) => t.scheduledWorkoutExerciseId.equals(scheduledExerciseId),
      )).go();

      // Save sets
      int savedCount = 0;
      for (final template in exerciseData.templates) {
        final weightController = _getController(
          exerciseData.workoutExercise.id,
          template.setNumber,
          'weight',
        );
        final repsController = _getController(
          exerciseData.workoutExercise.id,
          template.setNumber,
          'reps',
        );

        final weight = double.tryParse(weightController.text);
        final reps = int.tryParse(repsController.text);

        if (weight != null && reps != null) {
          await db
              .into(db.workoutSetTable)
              .insert(
                WorkoutSetTableCompanion.insert(
                  scheduledWorkoutExerciseId: scheduledExerciseId,
                  setNumber: template.setNumber,
                  weight: Value(weight),
                  reps: Value(reps),
                  isCompleted: const Value(true),
                ),
              );
          savedCount++;
        }
      }

      print('Saved $savedCount sets');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exercise saved'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print('Error saving exercise: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving exercise: $e')));
      }
    }
  }

  Future<void> _completeWorkout() async {
    if (widget.isReadOnly) {
      Navigator.pop(context);
      return;
    }
    setState(() => _isSaving = true);

    try {
      await _saveCurrentExercise();

      final db = context.read<AppDatabase>();

      await (db.update(
        db.scheduledWorkoutTable,
      )..where((t) => t.id.equals(widget.scheduledWorkout.scheduled.id))).write(
        ScheduledWorkoutTableCompanion(
          notes: Value(
            _workoutNoteController.text.isEmpty
                ? null
                : _workoutNoteController.text,
          ),
          isCompleted: const Value(true),
        ),
      );

      print('Workout completed successfully');

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Workout completed! 🎉')));
        Navigator.pop(context, true);
      }
    } catch (e) {
      print('Error completing workout: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error completing workout: $e')));
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _nextSet() {
    if (widget.isReadOnly) return;
    final currentExercise = _exercises[_currentExerciseIndex];
    if (_currentSetIndex < currentExercise.templates.length - 1) {
      setState(() {
        _currentSetIndex++;
      });
      showRestTimer(context);
    } else {
      _nextExercise();
    }
  }

  void _nextExercise() {
    if (widget.isReadOnly) return;
    if (_currentExerciseIndex < _exercises.length - 1) {
      _saveCurrentExercise();
      setState(() {
        _currentExerciseIndex++;
        _currentSetIndex = 0;
      });
    }
  }

  void _previousExercise() {
    if (widget.isReadOnly) return;
    if (_currentExerciseIndex > 0) {
      _saveCurrentExercise();
      setState(() {
        _currentExerciseIndex--;
        _currentSetIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // FIX #3: Show helpful message when no exercises
    if (_exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.scheduledWorkout.workout?.name ?? 'Workout'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 64,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              const Text(
                'This workout has no exercises',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please add exercises to this workout template',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    final currentExercise = _exercises[_currentExerciseIndex];
    final totalExercises = _exercises.length;
    final totalSets = _exercises.fold<int>(
      0,
      (sum, ex) => sum + ex.templates.length,
    );
    final completedSets =
        _exercises
            .take(_currentExerciseIndex)
            .fold<int>(0, (sum, ex) => sum + ex.templates.length) +
        _currentSetIndex;
    final progress = totalSets > 0 ? (completedSets + 1) / totalSets : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.scheduledWorkout.workout?.name ?? 'Workout'),
            if (widget.isReadOnly)
              Text(
                'Completed Workout (Read-Only)',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.green),
              ),
          ],
        ),
        actions: [
          if (!widget.isReadOnly)
            IconButton(
              icon: const Icon(Icons.timer),
              tooltip: 'Rest Timer',
              onPressed: () => showRestTimer(context),
            ),
          IconButton(
            icon: const Icon(Icons.note_add),
            tooltip: 'Workout Notes',
            onPressed: () => _showWorkoutNotesDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          if (!widget.isReadOnly)
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
            ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exercise ${_currentExerciseIndex + 1} of $totalExercises',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Set ${_currentSetIndex + 1} of ${currentExercise.templates.length}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => _showExerciseList(context),
                  icon: const Icon(Icons.list),
                  label: const Text('Jump to'),
                ),
              ],
            ),
          ),

          Expanded(child: _buildSetFocusedView(currentExercise, theme)),

          if (!widget.isReadOnly) _buildNavigationButtons(theme, l10n),
        ],
      ),
    );
  }

  Widget _buildSetFocusedView(_ExerciseWithSets exerciseData, ThemeData theme) {
    final currentTemplate = exerciseData.templates[_currentSetIndex];
    final previousSet = exerciseData.previousSets[currentTemplate.setNumber];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    exerciseData.exercise.name,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (exerciseData.exercise.description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      exerciseData.exercise.description!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: Text(
                'SET\n${currentTemplate.setNumber}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onSecondary,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // FIX #6: Display previous performance
          if (previousSet != null)
            Card(
              color: theme.colorScheme.surfaceVariant,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Last Time',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${previousSet.weight?.toStringAsFixed(1) ?? '--'} kg × ${previousSet.reps ?? '--'} reps',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Card(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No previous data for this set',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _workoutNoteController,
                    decoration: const InputDecoration(
                      hintText: 'How was the feeling of the exercise',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Weight input
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Weight (kg)', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _getController(
                      exerciseData.workoutExercise.id,
                      currentTemplate.setNumber,
                      'weight',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                    enabled: !widget.isReadOnly,
                    decoration: const InputDecoration(
                      hintText: '0.0',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Reps input
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reps', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _getController(
                      exerciseData.workoutExercise.id,
                      currentTemplate.setNumber,
                      'reps',
                    ),
                    keyboardType: TextInputType.number,
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                    enabled: !widget.isReadOnly,
                    decoration: const InputDecoration(
                      hintText: '0',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Sets',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...exerciseData.templates.asMap().entries.map((entry) {
                    final index = entry.key;
                    final template = entry.value;
                    final isCurrent = index == _currentSetIndex;
                    final isPast = index < _currentSetIndex;

                    final weightController = _getController(
                      exerciseData.workoutExercise.id,
                      template.setNumber,
                      'weight',
                    );
                    final repsController = _getController(
                      exerciseData.workoutExercise.id,
                      template.setNumber,
                      'reps',
                    );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color:
                                  isCurrent
                                      ? theme.colorScheme.primary
                                      : isPast
                                      ? Colors.green
                                      : theme.colorScheme.surfaceVariant,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${template.setNumber}',
                                style: TextStyle(
                                  color:
                                      isCurrent || isPast
                                          ? Colors.white
                                          : theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              (isPast || widget.isReadOnly) &&
                                      weightController.text.isNotEmpty &&
                                      repsController.text.isNotEmpty
                                  ? '${weightController.text} kg × ${repsController.text} reps'
                                  : isCurrent
                                  ? 'Current set'
                                  : 'Upcoming',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color:
                                    (isPast || widget.isReadOnly) &&
                                            weightController.text.isNotEmpty
                                        ? null
                                        : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(ThemeData theme, AppLocalizations l10n) {
    final isFirstExercise = _currentExerciseIndex == 0;
    final isLastExercise = _currentExerciseIndex == _exercises.length - 1;
    final currentExercise = _exercises[_currentExerciseIndex];
    final isLastSet = _currentSetIndex == currentExercise.templates.length - 1;
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    _isSaving
                        ? null
                        : (isLastSet && isLastExercise
                            ? _completeWorkout
                            : _nextSet),
                icon: Icon(
                  isLastSet && isLastExercise
                      ? Icons.check
                      : Icons.arrow_forward,
                ),
                label: Text(
                  isLastSet && isLastExercise
                      ? 'Complete Workout'
                      : isLastSet
                      ? 'Next Exercise'
                      : 'Next Set',
                  style: const TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor:
                      isLastSet && isLastExercise
                          ? Colors.green
                          : theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (!isFirstExercise)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _previousExercise,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Prev Exercise'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showWorkoutNotesDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Workout Notes'),
            content: TextField(
              controller: _workoutNoteController,
              decoration: const InputDecoration(
                hintText: 'How was your overall workout?',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              enabled: !widget.isReadOnly,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showExerciseList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => ListView.builder(
            itemCount: _exercises.length,
            itemBuilder: (context, index) {
              final exercise = _exercises[index];
              final isCurrent = index == _currentExerciseIndex;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      isCurrent
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceVariant,
                  child: Text('${index + 1}'),
                ),
                title: Text(
                  exercise.exercise.name,
                  style: TextStyle(
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text('${exercise.templates.length} sets'),
                onTap:
                    widget.isReadOnly
                        ? null
                        : () {
                          _saveCurrentExercise();
                          setState(() {
                            _currentExerciseIndex = index;
                            _currentSetIndex = 0;
                          });
                          Navigator.pop(context);
                        },
              );
            },
          ),
    );
  }
}

class _ExerciseWithSets {
  final ExerciseTableData exercise;
  final WorkoutExerciseTableData workoutExercise;
  final List<WorkoutSetTemplateData> templates;
  final Map<int, WorkoutSetTableData> previousSets;
  int? scheduledExerciseId;
  _ExerciseWithSets({
    required this.exercise,
    required this.workoutExercise,
    required this.templates,
    required this.previousSets,
    this.scheduledExerciseId,
  });
}
