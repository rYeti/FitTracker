import 'package:ForgeForm/core/app_database.dart';
import 'package:ForgeForm/l10n/app_localizations.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Simplified, focused screen for executing a workout
/// This replaces the complex nested UI in scheduled_workouts_view.dart
class ActiveWorkoutScreen extends StatefulWidget {
  final ScheduledWorkoutWithDetails scheduledWorkout;
  final DateTime scheduledDate;
  const ActiveWorkoutScreen({
    super.key,
    required this.scheduledWorkout,
    required this.scheduledDate,
  });
  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  int _currentExerciseIndex = 0;
  bool _isLoading = true;
  bool _isSaving = false;
  // Controllers for the current workout and exercises
  final TextEditingController _workoutNoteController = TextEditingController();
  final Map<int, TextEditingController> _exerciseNoteControllers = {};
  final Map<String, TextEditingController> _setControllers = {};
  // Data holders
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

  Future<void> _loadWorkoutData() async {
    setState(() => _isLoading = true);
    try {
      final db = context.read<AppDatabase>();
      final workout = widget.scheduledWorkout.workout;

      if (workout == null) {
        throw Exception('Workout not found');
      }

      // Load workout note
      final scheduledWorkoutData =
          await (db.select(db.scheduledWorkoutTable)..where(
            (t) => t.id.equals(widget.scheduledWorkout.scheduled.id),
          )).getSingleOrNull();

      if (scheduledWorkoutData?.notes != null) {
        _workoutNoteController.text = scheduledWorkoutData!.notes!;
      }

      // Load exercises with templates and previous sets
      final exercisesData = await db.workoutDao
          .getWorkoutExercisesWithTemplates(workout.id);

      final exercises = <_ExerciseWithSets>[];

      for (final exerciseData in exercisesData) {
        final exercise = exerciseData.$1;
        final templates = exerciseData.$2;
        final workoutExercise = exerciseData.$3;

        // Load previous sets for this exercise
        final previousSets = await db.workoutDao
            .getPreviousWorkoutSetsForExercise(
              exerciseId: exercise.id,
              beforeDate: widget.scheduledDate,
              templateWorkoutId:
                  widget.scheduledWorkout.scheduled.templateWorkoutId!,
              excludeScheduledWorkoutId: widget.scheduledWorkout.scheduled.id,
            );

        final previousSetsMap = {
          for (var set in previousSets) set.setNumber: set,
        };

        // Load existing exercise note
        final scheduledExercise =
            await (db.select(db.scheduledWorkoutExerciseTable)..where(
              (t) => t.workoutExerciseId.equals(workoutExercise.id),
            )).getSingleOrNull();

        final noteController = TextEditingController(
          text: scheduledExercise?.notes ?? '',
        );
        _exerciseNoteControllers[workoutExercise.id] = noteController;

        // Load existing set data if any
        final existingSets =
            await (db.select(db.workoutSetTable)..where(
              (t) => t.scheduledWorkoutExerciseId.equals(workoutExercise.id),
            )).get();

        final existingSetsMap = {
          for (var set in existingSets) set.setNumber: set,
        };

        // Initialize controllers for sets
        for (final template in templates) {
          final existingSet = existingSetsMap[template.setNumber];

          final weightKey = '${exercise.id}_${template.setNumber}_weight';
          final repsKey = '${exercise.id}_${template.setNumber}_reps';

          _setControllers[weightKey] = TextEditingController(
            text:
                existingSet?.weight?.toStringAsFixed(1) ??
                previousSetsMap[template.setNumber]?.weight?.toStringAsFixed(
                  1,
                ) ??
                '',
          );

          _setControllers[repsKey] = TextEditingController(
            text:
                existingSet?.reps?.toString() ??
                previousSetsMap[template.setNumber]?.reps?.toString() ??
                '',
          );
        }

        exercises.add(
          _ExerciseWithSets(
            exercise: exercise,
            workoutExercise: workoutExercise,
            templates: templates,
            previousSets: previousSetsMap,
          ),
        );
      }

      setState(() {
        _exercises = exercises;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading workout: $e')));
      }
      setState(() => _isLoading = false);
    }
  }

  TextEditingController? _getController(
    int exerciseId,
    int setNumber,
    String field,
  ) {
    final key = {exerciseId};
    '{setNumber}_$field';
    return _setControllers[key];
  }

  Future<void> _saveCurrentExercise() async {
    if (_currentExerciseIndex >= _exercises.length) return;
    final db = context.read<AppDatabase>();
    final exerciseData = _exercises[_currentExerciseIndex];

    try {
      // Save exercise note
      final noteController =
          _exerciseNoteControllers[exerciseData.workoutExercise.id]!;

      // Check if scheduled exercise exists
      final existingScheduledExercise =
          await (db.select(db.scheduledWorkoutExerciseTable)
                ..where(
                  (t) => t.workoutExerciseId.equals(
                    exerciseData.workoutExercise.id,
                  ),
                )
                ..where(
                  (t) => t.scheduledWorkoutId.equals(
                    widget.scheduledWorkout.scheduled.id,
                  ),
                ))
              .getSingleOrNull();

      final scheduledExerciseId =
          existingScheduledExercise?.id ??
          await db
              .into(db.scheduledWorkoutExerciseTable)
              .insert(
                ScheduledWorkoutExerciseTableCompanion.insert(
                  scheduledWorkoutId: widget.scheduledWorkout.scheduled.id,
                  workoutExerciseId: exerciseData.workoutExercise.id,
                  notes: Value(
                    noteController.text.isEmpty ? null : noteController.text,
                  ),
                ),
              );

      // Update note if exercise already exists
      if (existingScheduledExercise != null) {
        await (db.update(db.scheduledWorkoutExerciseTable)
          ..where((t) => t.id.equals(scheduledExerciseId))).write(
          ScheduledWorkoutExerciseTableCompanion(
            notes: Value(
              noteController.text.isEmpty ? null : noteController.text,
            ),
          ),
        );
      }

      // Delete existing sets for this exercise
      await (db.delete(db.workoutSetTable)..where(
        (t) => t.scheduledWorkoutExerciseId.equals(scheduledExerciseId),
      )).go();

      // Save sets
      for (final template in exerciseData.templates) {
        final weightController = _getController(
          exerciseData.exercise.id,
          template.setNumber,
          'weight',
        );
        final repsController = _getController(
          exerciseData.exercise.id,
          template.setNumber,
          'reps',
        );

        final weight = double.tryParse(weightController!.text);
        final reps = int.tryParse(repsController!.text);

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
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Exercise saved'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving exercise: $e')));
      }
    }
  }

  Future<void> _completeWorkout() async {
    setState(() => _isSaving = true);
    try {
      // Save current exercise first
      await _saveCurrentExercise();

      final db = context.read<AppDatabase>();

      // Save workout note and mark as completed
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

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Workout completed! 🎉')));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error completing workout: $e')));
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _nextExercise() {
    if (_currentExerciseIndex < _exercises.length - 1) {
      _saveCurrentExercise();
      setState(() {
        _currentExerciseIndex++;
      });
    }
  }

  void _previousExercise() {
    if (_currentExerciseIndex > 0) {
      _saveCurrentExercise();
      setState(() {
        _currentExerciseIndex--;
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

    if (_exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('No Exercises')),
        body: const Center(child: Text('This workout has no exercises')),
      );
    }

    final currentExercise = _exercises[_currentExerciseIndex];
    final progress = (_currentExerciseIndex + 1) / _exercises.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scheduledWorkout.workout?.name ?? 'Workout'),
        actions: [
          IconButton(
            icon: const Icon(Icons.note_add),
            tooltip: 'Workout Notes',
            onPressed: _showWorkoutNotesDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: theme.colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
          ),

          // Exercise counter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Exercise ${_currentExerciseIndex + 1} of ${_exercises.length}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _showExerciseList(context),
                  icon: const Icon(Icons.list),
                  label: const Text('Jump to'),
                ),
              ],
            ),
          ),

          // Exercise content
          Expanded(child: _buildExerciseCard(currentExercise, theme)),

          // Navigation buttons
          _buildNavigationButtons(theme, l10n),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(_ExerciseWithSets exerciseData, ThemeData theme) {
    final noteController =
        _exerciseNoteControllers[exerciseData.workoutExercise.id]!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise name
          Card(
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exerciseData.exercise.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  if (exerciseData.exercise.description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      exerciseData.exercise.description!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Sets table
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sets',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Table header
                  Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: Text('Set', style: theme.textTheme.labelMedium),
                      ),
                      Expanded(
                        child: Text(
                          'Previous',
                          style: theme.textTheme.labelMedium,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Weight (kg)',
                          style: theme.textTheme.labelMedium,
                        ),
                      ),
                      Expanded(
                        child: Text('Reps', style: theme.textTheme.labelMedium),
                      ),
                    ],
                  ),
                  const Divider(),

                  // Sets rows
                  ...exerciseData.templates.map((template) {
                    final previousSet =
                        exerciseData.previousSets[template.setNumber];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: Text(
                              '${template.setNumber}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              previousSet != null
                                  ? '${previousSet.weight?.toStringAsFixed(0) ?? '--'} × ${previousSet.reps ?? '--'}'
                                  : '--',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _getController(
                                exerciseData.exercise.id,
                                template.setNumber,
                                'weight',
                              ),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                isDense: true,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _getController(
                                exerciseData.exercise.id,
                                template.setNumber,
                                'reps',
                              ),
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                isDense: true,
                              ),
                              textAlign: TextAlign.center,
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
          const SizedBox(height: 16),

          // Exercise notes
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Exercise Notes',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: noteController,
                    decoration: const InputDecoration(
                      hintText: 'How did this exercise feel?',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
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
        child: Row(
          children: [
            if (!isFirstExercise)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _previousExercise,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                ),
              ),
            if (!isFirstExercise && !isLastExercise) const SizedBox(width: 16),
            Expanded(
              flex: isFirstExercise || isLastExercise ? 1 : 2,
              child: ElevatedButton.icon(
                onPressed:
                    _isSaving
                        ? null
                        : (isLastExercise ? _completeWorkout : _nextExercise),
                icon: Icon(isLastExercise ? Icons.check : Icons.arrow_forward),
                label: Text(
                  isLastExercise ? 'Complete Workout' : 'Next Exercise',
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor:
                      isLastExercise ? Colors.green : theme.colorScheme.primary,
                ),
              ),
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
                onTap: () {
                  _saveCurrentExercise();
                  setState(() {
                    _currentExerciseIndex = index;
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
  _ExerciseWithSets({
    required this.exercise,
    required this.workoutExercise,
    required this.templates,
    required this.previousSets,
  });
}
