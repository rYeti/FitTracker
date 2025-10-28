import 'package:flutter/material.dart';

class WorkoutsListView extends StatefulWidget {
  const WorkoutsListView();

  @override
  State<WorkoutsListView> createState() => _WorkoutsListViewState();
}

class _WorkoutsListViewState extends State<WorkoutsListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workouts List ')),
      body: const Center(child: Text('Edit Workout View Content')),
    );
  }
}
