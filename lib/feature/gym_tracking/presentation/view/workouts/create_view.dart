import 'package:fittnes_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fittnes_tracker/core/app_database.dart';
import 'package:fittnes_tracker/feature/workout_planning/data/models/workout.dart';

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
  List<TextEditingController> _workoutControllers = [];
  List<TextEditingController> _workoutExerciseControllers = [];
  Map<DateTime, int> _dateToWorkoutIndex = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Create Workout')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Step ${_currentStep + 1} of 3",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 20),
              Expanded(child: _buildStepContent()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    ElevatedButton(onPressed: _goBack, child: Text("Back")),
                  ElevatedButton(
                    onPressed: _nextOrSave,
                    child: Text(_currentStep == 2 ? "Save" : "Next"),
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
    final db = context.read<AppDatabase>();
    final workoutName = _workoutNameController.text.trim();
    if (workoutName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a workout name')),
      );
      return;
    }
    final workout = Workout(
      name: workoutName,
      isTemplate: false, // This is an actual workout, not a template
      exercises: [], // No exercises for now (we'll add this later)
    );
    await db.workoutDao.saveCompleteWorkout(workout);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Workout saved successfully')));
  }

  @override
  void dispose() {
    _workoutNameController.dispose();
    for (var controller in _workoutControllers) {
      controller.dispose();
    }
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
    if (_currentStep == 0) {
      if (_workoutNameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a workout name')),
        );
        return;
      }
    } else if (_currentStep == 1) {
      if (_workoutControllers.isEmpty ||
          _workoutControllers.any((c) => c.text.trim().isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter names for all workout days'),
          ),
        );
        return;
      }
    } else if (_currentStep == 2) {
      if (widget.selectedDates != null) {
        for (var date in widget.selectedDates!) {
          if (!_dateToWorkoutIndex.containsKey(date)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please assign a workout to all selected dates'),
              ),
            );
            return;
          }
        }
      }
    }
    setState(() {
      if (_currentStep <= 2) {
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
        return _workoutDayNames();
      case 2:
        return _reviewWorkout();
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
          Text(
            widget.selectedDates != null
                ? 'Training on ${widget.selectedDates!.length} days'
                : 'No dates selected',
          ),
        ],
      ),
    );
  }

  Widget _workoutDayNames() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _workoutControllers.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _workoutControllers[index],
                        decoration: InputDecoration(
                          icon: const Icon(Icons.fitness_center),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _workoutControllers[index].dispose();
                          _workoutControllers.removeAt(index);
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _addWorkoutForDay,
            child: Text('Add Workout'),
          ),
        ],
      ),
    );
  }

  Widget _reviewWorkout() {
    return Center(
      child: ListView.builder(
        itemCount: widget.selectedDates?.length ?? 0,
        itemBuilder: (context, index) {
          final date = widget.selectedDates![index];
          return ListTile(
            title: Text('${date.day}/${date.month}/${date.year}'),
            trailing: DropdownButton<int>(
              value: _dateToWorkoutIndex[date],
              hint: Text('Select Workout'),
              items:
                  _workoutControllers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final controller = entry.value;
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(controller.text),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _dateToWorkoutIndex[date] = value!;
                });
              },
            ),
          );
        },
      ),
    );
  }

  void _addWorkoutForDay() {
    setState(() {
      _workoutControllers.add(TextEditingController());
    });
  }
}
