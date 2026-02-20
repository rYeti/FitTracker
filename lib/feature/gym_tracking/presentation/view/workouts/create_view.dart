import 'package:drift/drift.dart' as drift hide Column;
import 'dart:convert';
import 'package:ForgeForm/core/app_database.dart';
import 'package:ForgeForm/feature/workout_planning/data/models/workout.dart';
import 'package:ForgeForm/feature/workout_planning/data/models/exercise.dart';
import 'package:ForgeForm/feature/gym_tracking/presentation/widgets/exercise_selection_modal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ForgeForm/l10n/app_localizations.dart';
import 'package:ForgeForm/feature/gym_tracking/data/models/set_template.dart';

class CreateWorkoutView extends StatefulWidget {
  // This is like a constructor parameter in C#
  final List<DateTime>? selectedDates;

  const CreateWorkoutView({
    Key? key,
    this.selectedDates, // nullable so it works if called without dates too
  }) : super(key: key);

  @override
  State<CreateWorkoutView> createState() => _CreateWorkoutViewState();
}

class _CreateWorkoutViewState extends State<CreateWorkoutView> {
  final _workoutNameController = TextEditingController();
  int _currentStep = 0;

  List<String?> _cyclePattern = []; // null = rest day, 0/1/2... = workout index
  DateTime? _startDate = DateTime.now(); // Default to today

  // Map to store exercises for each workout name
  Map<String, List<(Exercise, List<SetTemplates>)>> _workoutExercises = {};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text(l10n.createWorkout)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.stepXofY(_currentStep + 1, 3),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 20),
              Expanded(child: _buildStepContent()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    ElevatedButton(onPressed: _goBack, child: Text(l10n.back)),
                  ElevatedButton(
                    onPressed: _nextOrSave,
                    child: Text(_currentStep == 2 ? l10n.save : l10n.next),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveWorkout() async {
    final l10n = AppLocalizations.of(context)!;
    final db = context.read<AppDatabase>();
    final Map<String, int> workoutMap = {};

    final workouts =
        _cyclePattern.where((name) => name != "Rest Day").toSet().toList();

    await (db.update(db.workoutPlanTable)..where(
      (t) => t.isActive.equals(true),
    )).write(WorkoutPlanTableCompanion(isActive: drift.Value(false)));

    final subWorkout = WorkoutPlanTableCompanion.insert(
      name: _workoutNameController.text.trim(),
      cyclePatternJson: jsonEncode(_cyclePattern),
      startDate: _startDate!,
      isActive: const drift.Value(true),
    );
    final planId = await db.into(db.workoutPlanTable).insert(subWorkout);

    final existingRestDay = await db.workoutDao.getWorkoutByNameOrNull(
      "Rest Day",
    );
    if (existingRestDay == null) {
      final workout = Workout(
        name: "Rest Day",
        isTemplate: true,
        exercises: [],
        difficulty: WorkoutDifficulty.beginner,
        estimatedDurationMinutes: 0,
      );
      final savedWorkout = await db.workoutDao.saveCompleteWorkout(workout);
      workoutMap["Rest Day"] = savedWorkout;
    } else {
      workoutMap["Rest Day"] = existingRestDay.id;
    }

    for (var workoutName in workouts) {
      // Get exercises for this workout, or empty list if none added
      final exercises = _workoutExercises[workoutName] ?? [];

      final workout = Workout(
        name: workoutName!,
        isTemplate: true,
        exercises: [], // Will be populated after saving
        difficulty: WorkoutDifficulty.intermediate,
        estimatedDurationMinutes: 60,
      );
      final savedWorkout = await db.workoutDao.saveCompleteWorkout(workout);
      workoutMap[workoutName] = savedWorkout;

      // Link the newly created workout to the plan so it shows up in plan views
      try {
        await db
            .into(db.workoutPlanWorkoutTable)
            .insert(
              WorkoutPlanWorkoutTableCompanion(
                planId: drift.Value(planId),
                workoutId: drift.Value(savedWorkout),
              ),
            );
        print('Created junction: plan $planId -> workout $savedWorkout');
      } catch (e) {
        print(
          'Failed to create plan->workout junction for plan $planId workout $savedWorkout: $e',
        );
      }

      // Now add exercises to the saved workout if any were selected
      if (exercises.isNotEmpty) {
        for (int i = 0; i < exercises.length; i++) {
          final (exercise, sets) = exercises[i];

          // Save exercise if it doesn't have an ID yet
          int exerciseId;
          if (exercise.id == null) {
            exerciseId = await db.exerciseDao.saveExercise(
              db.exerciseDao.modelToEntity(exercise),
            );
          } else {
            exerciseId = exercise.id!;
          }

          final workoutExerciseId = await db
              .into(db.workoutExerciseTable)
              .insert(
                WorkoutExerciseTableCompanion.insert(
                  workoutId: savedWorkout,
                  exerciseId: exerciseId,
                  orderPosition: i,
                ),
              );

          // Save set templates for this exercise
          final exerciseSets = sets;
          if (exerciseSets.isNotEmpty) {
            await db.batch((batch) {
              for (
                int setIndex = 0;
                setIndex < exerciseSets.length;
                setIndex++
              ) {
                final set = exerciseSets[setIndex];
                batch.insert(
                  db.workoutSetTemplateTable,
                  WorkoutSetTemplateTableCompanion.insert(
                    workoutExerciseId: workoutExerciseId,
                    setNumber: set.setNumber,
                    targetReps: set.targetReps,
                    orderPosition: setIndex,
                  ),
                );
              }
            });
          }
        }
      }
    }

    for (int day = 0; day < 360; day++) {
      final date = _startDate!.add(Duration(days: day));
      final cycleIndex = day % _cyclePattern.length;
      final workoutName = _cyclePattern[cycleIndex];
      final workoutId = workoutMap[workoutName];

      final scheduledWorkout = ScheduledWorkoutTableCompanion.insert(
        workoutId: workoutId!,
        templateWorkoutId: drift.Value(workoutId),
        scheduledDate: date,
        workoutPlanId: drift.Value(planId),
      );

      await db.scheduledWorkoutDao.scheduleWorkout(scheduledWorkout);
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.workoutSavedSuccessfully)));
    await Future.delayed(Duration(milliseconds: 500));
    if (context.mounted) {
      Navigator.of(context).pop(true); // THIS is the missing part
    }
  }

  @override
  void dispose() {
    _workoutNameController.dispose();
    super.dispose();
  }

  _goBack() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  void _nextOrSave() {
    final l10n = AppLocalizations.of(context)!;
    if (_currentStep == 0) {
      if (_workoutNameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.pleaseEnterWorkoutName)));
        return;
      }
    } else if (_currentStep == 1) {
      if (_cyclePattern.isEmpty ||
          _cyclePattern.every((element) => element == "Rest Day")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.pleaseEnterAtLeastOneWorkoutDay)),
        );
        return;
      }
    } else if (_currentStep == 2) {
      if (_startDate == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.pleaseSelectStartDate)));
        return;
      }
    }
    setState(() {
      if (_currentStep < 2) {
        _currentStep++;
      } else {
        _saveWorkout();
      }
    });
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _workoutName();
      case 1:
        return _buildCyclePattern();
      case 2:
        return _dateSelection();
      default:
        return Container();
    }
  }

  Widget _workoutName() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _workoutNameController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.workoutName,
              icon: const Icon(Icons.fitness_center),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCyclePattern() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cyclePattern.length,
              itemBuilder: (context, index) {
                final entry = _cyclePattern[index];

                // If it's a rest day (null)
                if (entry == "Rest Day") {
                  return ListTile(
                    leading: Icon(Icons.hotel),
                    title: Text(l10n.dayRestDay(index + 1)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _cyclePattern.removeAt(index);
                        });
                      },
                    ),
                  );
                }

                // If it's a workout (has a name)
                return ExpansionTile(
                  leading: Icon(Icons.fitness_center),
                  title: Text(l10n.dayWorkout(index + 1, entry!)),
                  subtitle:
                      _workoutExercises[entry]?.isNotEmpty == true
                          ? Text(
                            '${_workoutExercises[entry]!.length} exercise(s)',
                            style: TextStyle(fontSize: 12),
                          )
                          : null,
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _cyclePattern.removeAt(index);
                        _workoutExercises.remove(entry);
                      });
                    },
                  ),
                  children: [
                    if (_workoutExercises[entry]?.isEmpty ?? true)
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(l10n.noExercisesYet),
                      ),
                    if (_workoutExercises[entry]?.isNotEmpty == true)
                      ..._workoutExercises[entry]!.asMap().entries.map((e) {
                        final exerciseIndex = e.key;
                        return _ExerciseSetConfigItem(
                          exerciseTuple: e.value,
                          workoutName: entry,
                          exerciseIndex: exerciseIndex,
                          onSetsChanged: (newSets) {
                            setState(() {
                              final (exercise, _) =
                                  _workoutExercises[entry]![exerciseIndex];
                              _workoutExercises[entry]![exerciseIndex] = (
                                exercise,
                                newSets,
                              );
                            });
                          },
                          onDelete: () {
                            setState(() {
                              _workoutExercises[entry]!.removeAt(exerciseIndex);
                            });
                          },
                        );
                      }).toList(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton.icon(
                        onPressed: () => _addExerciseToWorkout(entry),
                        icon: Icon(Icons.add),
                        label: Text('Add Exercise'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 40),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(onPressed: _addWorkout, child: Text(l10n.addWorkout)),
          SizedBox(height: 10),
          ElevatedButton(onPressed: _addRestDay, child: Text(l10n.addRestDay)),
        ],
      ),
    );
  }

  void _addWorkout() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    var workoutName = '';
    final result = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n.workoutNameLabel),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'e.g., Upper A'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () {
                  workoutName = controller.text;
                  Navigator.pop(context, workoutName);
                },
                child: Text(l10n.add),
              ),
            ],
          ),
    );

    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        _cyclePattern.add(result.trim());
      });
    }
  }

  void _addRestDay() {
    setState(() {
      _cyclePattern.add("Rest Day");
    });
  }

  Future<void> _addExerciseToWorkout(String workoutName) async {
    final exercise = await ExerciseSelectionModal.show(context);

    if (exercise != null) {
      setState(() {
        if (_workoutExercises[workoutName] == null) {
          _workoutExercises[workoutName] = [];
        }
        _workoutExercises[workoutName]!.add((exercise, []));
      });
    }
  }

  Widget _dateSelection() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText:
                  _startDate == null
                      ? l10n.selectStartDate
                      : DateFormat('yyyy-MM-dd').format(_startDate!),
              icon: Icon(Icons.date_range),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                setState(() {
                  _startDate = pickedDate;
                });
              }
            },
            child: Text(l10n.selectStartDate),
          ),
        ],
      ),
    );
  }
}

class _ExerciseSetConfigItem extends StatefulWidget {
  final (Exercise, List<SetTemplates>) exerciseTuple;
  final String workoutName;
  final int exerciseIndex;
  final Function(List<SetTemplates>) onSetsChanged;
  final VoidCallback onDelete;

  const _ExerciseSetConfigItem({
    required this.exerciseTuple,
    required this.workoutName,
    required this.exerciseIndex,
    required this.onSetsChanged,
    required this.onDelete,
  });

  @override
  State<_ExerciseSetConfigItem> createState() => _ExerciseSetConfigItemState();
}

class _ExerciseSetConfigItemState extends State<_ExerciseSetConfigItem> {
  late List<TextEditingController> _controllers;
  late List<SetTemplates> _sets;

  @override
  void initState() {
    super.initState();
    final (_, sets) = widget.exerciseTuple;
    _sets = List.from(sets);

    _controllers =
        _sets
            .map((set) => TextEditingController(text: set.targetReps))
            .toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _notifyParent() {
    final updatedSets = List.generate(
      _sets.length,
      (i) => SetTemplates(
        setNumber: i + 1,
        targetRange: _sets[i].targetRange,
        targetReps: _controllers[i].text.trim(),
      ),
    );
    widget.onSetsChanged(updatedSets);
  }

  @override
  Widget build(BuildContext context) {
    final (exercise, _) = widget.exerciseTuple;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ExpansionTile(
        leading: Text('${widget.exerciseIndex + 1}.'),
        title: Text(exercise.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (exercise.description != null &&
                exercise.description!.isNotEmpty)
              Text(
                exercise.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12),
              ),
            if (_sets.isEmpty)
              Text(
                l10n.noSetsConfigured,
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              )
            else
              Text(
                '${_sets.length} ${l10n.sets}',
                style: TextStyle(fontSize: 12),
              ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, size: 20),
          onPressed: widget.onDelete,
        ),
        children: [
          ..._sets.asMap().entries.map((entry) {
            final index = entry.key;
            final set = entry.value;
            final controller = _controllers[index];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text('Set ${set.setNumber}:'),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: l10n.reps,
                        hintText: l10n.repsHelperText,
                      ),
                      onChanged: (value) => _notifyParent(),
                    ),
                  ),
                ],
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  final newSetNumber = _sets.length + 1;
                  _sets.add(
                    SetTemplates(
                      setNumber: newSetNumber,
                      targetRange: '',
                      targetReps: '',
                    ),
                  );
                  _controllers.add(TextEditingController());
                  _notifyParent();
                });
              },
              icon: Icon(Icons.add),
              label: Text(l10n.addSet),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                _removeSet(_sets.length - 1);
              },
              icon: Icon(Icons.remove),
              label: Text(l10n.removeSet),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _removeSet(int index) {
    setState(() {
      if (_sets.length > 1) {
        _sets.removeAt(index);
        _controllers[index].dispose();
        _controllers.removeAt(index);

        for (int i = 0; i < _sets.length; i++) {
          _sets[i] = SetTemplates(
            setNumber: i + 1,
            targetRange: _sets[i].targetRange,
            targetReps: _sets[i].targetReps,
          );
        }
        _notifyParent();
      }
    });
  }
}
