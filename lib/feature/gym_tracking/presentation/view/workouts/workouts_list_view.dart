import 'dart:convert';
import 'dart:io';
import 'package:ForgeForm/core/app_database.dart';
import 'package:ForgeForm/core/di/service_locator.dart';
import 'package:ForgeForm/feature/gym_tracking/presentation/view/workouts/edit_view.dart';
import 'package:ForgeForm/feature/workout_planning/data/models/workout_plan.dart';
import 'package:ForgeForm/l10n/app_localizations.dart';
import 'package:drift/drift.dart' as drift;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class WorkoutsListView extends StatefulWidget {
  const WorkoutsListView();

  @override
  State<WorkoutsListView> createState() => _WorkoutsListViewState();
}

class _WorkoutsListViewState extends State<WorkoutsListView> {
  List<WorkoutPlan>? _plans;
  bool _loading = true;
  int? _activePlanId;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    setState(() => _loading = true);

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.workouts)),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _plans == null || _plans!.isEmpty
              ? Center(child: Text('No workout plans found'))
              : ListView.builder(
                itemCount: _plans!.length,
                itemBuilder: (context, index) {
                  final plan = _plans![index];
                  return ListTile(
                    title: Text(plan.name),
                    subtitle: Text('${plan.workouts.length} workouts'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_activePlanId == plan.id)
                          const Icon(Icons.check_circle, color: Colors.green),
                        TextButton(
                          onPressed: () => _setActivePlan(plan.id!),
                          child: Text(
                            _activePlanId == plan.id ? 'Active' : 'Set Active',
                            style: TextStyle(
                              color:
                                  _activePlanId == plan.id
                                      ? Colors.green
                                      : null,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => EditWorkoutView(planId: plan.id),
                              ),
                            ).then((result) {
                              _loadPlans();
                              if (result == true) {
                                Navigator.pop(context, true);
                              }
                            });
                          },
                        ),
                      ],
                    ),
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
}
