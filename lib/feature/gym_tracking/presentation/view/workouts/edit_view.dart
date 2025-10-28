import 'package:flutter/material.dart';

class EditWorkoutView extends StatefulWidget {
  final int workoutId;
  const EditWorkoutView({super.key, required this.workoutId});

  @override
  _EditWorkoutViewState createState() => _EditWorkoutViewState();
}

class _EditWorkoutViewState extends State<EditWorkoutView> {
  @override
  Widget build(BuildContext context) {
    final workoutId = widget.workoutId;
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Workout')),
      body: Center(child: Text('Edit Workout Form for Workout ID: $workoutId')),
    );
  }
}
