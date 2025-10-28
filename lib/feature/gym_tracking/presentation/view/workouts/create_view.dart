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
  int _numberOfDays = 2;
  List<TextEditingController> _dayControllers = [];

  @override
  Widget build(BuildContext context) {
    final selected = widget.selectedDates;
    final hasDates = selected != null && selected.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Workout')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Step ${_currentStep + 1} of 4"),
              SizedBox(height: 20),
              Expanded(child: _buildStepContent()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    TextButton(onPressed: _goBack, child: Text("back")),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _saveWorkout,
        child: const Icon(Icons.save),
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
    super.dispose();
  }

  _goBack() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
  }

  _nextOrSave() {
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
        return _workoutDayNames();
      case 2:
        return _reviewWorkout();
      default:
        return Container();
    }
  }

  Widget _workoutName() {
    return Center(child: );
  }

  Widget _workoutDayNames() {
    return Center(child: Text('Step 2: Name days'));
  }

  Widget _reviewWorkout() {
    return Center(child: Text('Step 3: Review'));
  }
}
