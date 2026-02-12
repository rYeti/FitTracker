import 'dart:convert';
import 'dart:io';

import 'package:ForgeForm/core/app_database.dart';
import 'package:ForgeForm/core/di/service_locator.dart';
import 'package:ForgeForm/feature/gym_tracking/presentation/providers/workout_provider.dart';
import 'package:ForgeForm/feature/gym_tracking/presentation/view/workouts/create_view.dart';
import 'package:ForgeForm/feature/gym_tracking/presentation/view/workouts/edit_view.dart';
import 'package:ForgeForm/feature/workout_planning/data/models/workout_plan.dart';
import 'package:ForgeForm/l10n/app_localizations.dart';
import 'package:drift/drift.dart' as drift;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutsListView extends StatefulWidget {
  const WorkoutsListView({super.key});
  @override
  State<WorkoutsListView> createState() => WorkoutsListViewState();
}

class WorkoutsListViewState extends State<WorkoutsListView> {
  List<WorkoutPlan>? _plans;
  bool _loading = true;
  int? _activePlanId;
  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    final dao = sl<AppDatabase>().workoutPlanDao;
    final planData = await dao.getAllPlans();

    final plans = await Future.wait(
      planData.map((p) => dao.getCompletePlanById(p.id)),
    );

    setState(() {
      _plans = plans.whereType<WorkoutPlan>().toList();
      _loading = false;

      // Set active plan
      final activePlan = _plans!.where((p) => p.isActive).firstOrNull;
      _activePlanId = activePlan?.id;
    });
  }

  Future<void> _setActivePlan(int planId) async {
    // Deactivate all plans
    await (sl<AppDatabase>().update(sl<AppDatabase>().workoutPlanTable)..where(
      (p) => p.isActive.equals(true),
    )).write(WorkoutPlanTableCompanion(isActive: drift.Value(false)));

    // Activate the selected plan
    await (sl<AppDatabase>().update(sl<AppDatabase>().workoutPlanTable)..where(
      (p) => p.id.equals(planId),
    )).write(WorkoutPlanTableCompanion(isActive: drift.Value(true)));

    setState(() {
      _activePlanId = planId;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Workout plan set as active')));
  }

  Future<void> _importCsv() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      final file = result.files.single;

      String content;
      if (file.bytes != null) {
        content = utf8.decode(file.bytes!);
      } else if (file.path != null) {
        // Fallback to reading from disk when bytes aren't provided
        try {
          content = await File(file.path!).readAsString();
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to read selected file: $e')),
            );
          }
          return;
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not read selected file')),
          );
        }
        return;
      }

      // Ask user whether to create a workout plan for the imported data
      final createPlan = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text('Import Options'),
              content: const Text(
                'Create a workout plan for the imported data?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Yes'),
                ),
              ],
            ),
      );

      String? chosenPlanName;
      final willCreatePlan = createPlan == true;
      if (willCreatePlan) {
        // Ask for a plan name
        chosenPlanName = await showDialog<String?>(
          context: context,
          builder: (context) {
            final controller = TextEditingController(text: 'Imported Plan');
            return AlertDialog(
              title: Text('Plan name'),
              content: TextField(controller: controller),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed:
                      () => Navigator.pop(context, controller.text.trim()),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );

        if (chosenPlanName != null && chosenPlanName.trim().isEmpty)
          chosenPlanName = null;
      }

      // Show immediate feedback while import runs
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Importing workouts...')));
      }

      try {
        final dao = sl<AppDatabase>().workoutDao;
        final createdPlanId = await dao.importCsvWorkouts(
          content,
          createPlan: willCreatePlan,
          planName: chosenPlanName,
        );

        if (mounted) {
          if (createdPlanId != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Workouts imported and plan created (id=$createdPlanId)',
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Workouts imported successfully')),
            );
          }

          _loadPlans();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Import failed: $e')));
        }
      }
    }
  }

  /// Show dialog to edit workout name
  Future<void> _showEditNameDialog(WorkoutTableData workout) async {
    final controller = TextEditingController(text: workout.name);
    final result = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Workout Name'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Workout Name',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  Navigator.pop(context, value.trim());
                }
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final newName = controller.text.trim();
                  if (newName.isNotEmpty) {
                    Navigator.pop(context, newName);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
    if (result != null && result != workout.name) {
      await _updateWorkoutName(workout.id, result);
    }
  }

  /// Update workout name in database
  Future<void> _updateWorkoutName(int workoutId, String newName) async {
    try {
      final db = context.read<AppDatabase>();
      await (db.update(db.workoutTable)..where(
        (t) => t.id.equals(workoutId),
      )).write(WorkoutTableCompanion(name: drift.Value(newName)));

      // Refresh the list
      if (mounted) {
        context.read<WorkoutProvider>().loadTemplates();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Workout renamed to "$newName"')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating name: $e')));
      }
    }
  }

  /// Show dialog to edit workout description and duration
  Future<void> _showEditDetailsDialog(WorkoutTableData workout) async {
    final descriptionController = TextEditingController(
      text: workout.description ?? '',
    );
    final durationController = TextEditingController(
      text: workout.estimatedDurationMinutes.toString(),
    );
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Workout Details'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: durationController,
                    decoration: const InputDecoration(
                      labelText: 'Estimated Duration (minutes)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final duration = int.tryParse(durationController.text);
                  if (duration != null && duration > 0) {
                    Navigator.pop(context, {
                      'description': descriptionController.text.trim(),
                      'duration': duration,
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid duration'),
                      ),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );

    if (result != null) {
      await _updateWorkoutDetails(workout.id, result);
    }
  }

  /// Update workout details in database
  Future<void> _updateWorkoutDetails(
    int workoutId,
    Map<String, dynamic> details,
  ) async {
    try {
      final db = context.read<AppDatabase>();
      await (db.update(db.workoutTable)
        ..where((t) => t.id.equals(workoutId))).write(
        WorkoutTableCompanion(
          description: drift.Value(
            details['description'].isEmpty ? null : details['description'],
          ),
          estimatedDurationMinutes: drift.Value(details['duration']),
        ),
      );

      // Refresh the list
      if (mounted) {
        context.read<WorkoutProvider>().loadTemplates();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout details updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating details: $e')));
      }
    }
  }

  /// Show bottom sheet with edit options
  void _showEditOptions(WorkoutTableData workout) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Name'),
                  onTap: () {
                    Navigator.pop(context);
                    _showEditNameDialog(workout);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('Edit Details'),
                  subtitle: const Text('Description and duration'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditWorkoutView(planId: workout.id),
                      ),
                    ).then((result) {
                      _loadPlans();
                      if (result == true) {
                        Navigator.pop(context, true);
                      }
                    });
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Delete Workout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmation(workout);
                  },
                ),
              ],
            ),
          ),
    );
  }

  /// Show delete confirmation dialog
  Future<void> _showDeleteConfirmation(WorkoutTableData workout) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Workout'),
            content: Text(
              'Are you sure you want to delete "${workout.name}"?\n\nThis will also delete all scheduled instances of this workout.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      await _deleteWorkout(workout.id);
    }
  }

  /// Delete workout from database
  Future<void> _deleteWorkout(int workoutId) async {
    try {
      final db = context.read<AppDatabase>();
      // Delete the workout (cascade should handle related records)
      await (db.delete(db.workoutTable)
        ..where((t) => t.id.equals(workoutId))).go();

      // Refresh the list
      if (mounted) {
        context.read<WorkoutProvider>().loadTemplates();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Workout deleted')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting workout: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.workouts)),
      body: Consumer<WorkoutProvider>(
        builder: (context, provider, _) {
          if (provider.templates.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.fitness_center,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    //TODO #26 - localize
                    'No workouts found',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CreateWorkoutView()),
                      );
                      if (mounted) {
                        provider.loadTemplates();
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Your First Workout'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.templates.length,
            itemBuilder: (context, index) {
              final workout = provider.templates[index];
              // final plan = _plans![index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.fitness_center,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(
                    workout.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (workout.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          workout.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        '${workout.estimatedDurationMinutes} minutes',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_activePlanId == workout.id)
                        const Icon(Icons.check_circle, color: Colors.green),
                      TextButton(
                        onPressed: () => _setActivePlan(workout.id!),
                        child: Text(
                          _activePlanId == workout.id ? 'Active' : 'Set Active',
                          style: TextStyle(
                            color:
                                _activePlanId == workout.id
                                    ? Colors.green
                                    : null,
                          ),
                        ),
                      ),
                      // Quick edit name button
                      // More options button
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        tooltip: 'More Options',
                        onPressed: () => _showEditOptions(workout),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Show workout details or navigate to edit view
                    _showEditOptions(workout);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _importCsv,
        tooltip: 'Import CSV',
        child: const Icon(Icons.file_upload),
      ),
    );
  }
}
