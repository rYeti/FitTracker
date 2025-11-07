import 'package:drift/drift.dart' as drift hide Column;
import 'dart:convert';
import 'package:ForgeForm/core/app_database.dart';
import 'package:ForgeForm/feature/workout_planning/data/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ForgeForm/l10n/app_localizations.dart';

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
  DateTime? _startDate;

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
      final workout = Workout(
        name: workoutName!,
        isTemplate: true,
        exercises: [],
        difficulty: WorkoutDifficulty.intermediate,
        estimatedDurationMinutes: 60,
      );
      final savedWorkout = await db.workoutDao.saveCompleteWorkout(workout);
      workoutMap[workoutName] = savedWorkout;
    }

    for (int day = 0; day < 30; day++) {
      final date = _startDate!.add(Duration(days: day));
      final cycleIndex = day % _cyclePattern.length;
      final workoutName = _cyclePattern[cycleIndex];
      final workoutId = workoutMap[workoutName];

      final scheduledWorkout = ScheduledWorkoutTableCompanion.insert(
        workoutId: workoutId!,
        scheduledDate: date,
        workoutPlanId: drift.Value(planId),
      );

      await db.scheduledWorkoutDao.scheduleWorkout(scheduledWorkout);
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.workoutSavedSuccessfully)));
    await Future.delayed(Duration(milliseconds: 500));
    Navigator.pop(context);
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
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _cyclePattern.removeAt(index);
                      });
                    },
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(l10n.noExercisesYet),
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
