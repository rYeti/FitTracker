import 'package:fittnes_tracker/core/app_database.dart';
import 'package:fittnes_tracker/feature/gym_tracking/presentation/view/workouts/create_view.dart';
import 'package:fittnes_tracker/feature/gym_tracking/presentation/view/workouts/workouts_list_view.dart';
import 'package:fittnes_tracker/feature/gym_tracking/presentation/providers/workout_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scheduled_workout_provider.dart';
import 'workouts/date_selection_sheet.dart';

class ScheduledWorkoutsView extends StatefulWidget {
  const ScheduledWorkoutsView({super.key});

  @override
  State<ScheduledWorkoutsView> createState() => _ScheduledWorkoutsViewState();
}

class _ScheduledWorkoutsViewState extends State<ScheduledWorkoutsView> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScheduleWorkoutProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Workouts'),
            actions: [
              IconButton(
                tooltip: 'Seed workout templates (debug)',
                icon: const Icon(Icons.file_download),
                onPressed: () async {
                  final db = context.read<AppDatabase>();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Seeding templates...')),
                  );
                  try {} catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Seeding failed: $e')),
                    );
                  }
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}',
                      ),
                      onPressed: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (d != null) {
                          setState(() => selectedDate = d);
                          await provider.loadForDate(d);
                        }
                      },
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => provider.loadForDate(selectedDate),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: const Center(child: Text('No scheduled workouts')),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Create or edit workouts',
            child: const Icon(Icons.add),
            onPressed: () async {
              showModalBottomSheet(
                context: context,
                builder:
                    (_) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.schedule),
                            title: Text('New Workout'),
                            onTap: () async {
                              // Close the bottom sheet first
                              Navigator.of(context).pop();

                              // Show the date selection sheet
                              final pickedDates =
                                  await showModalBottomSheet<List<DateTime>>(
                                    context: context,
                                    isScrollControlled:
                                        true, // Allows the sheet to be taller
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                    ),
                                    builder:
                                        (_) => const FractionallySizedBox(
                                          heightFactor:
                                              0.85, // 85% of screen height
                                          child: DateSelectionSheet(),
                                        ),
                                  );

                              // If user cancelled or selected nothing, stop
                              if (pickedDates == null || pickedDates.isEmpty) {
                                return;
                              }

                              // Navigate to CreateWorkoutView with the dates
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (_) => CreateWorkoutView(
                                        selectedDates: pickedDates,
                                      ),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.remove_red_eye),
                            title: Text('View workouts'),
                            onTap: () {
                              final result = Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => WorkoutsListView(),
                                ),
                              );
                              if (result == true) {
                                context.read<WorkoutProvider>().loadTemplates();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
              );
            },
          ),
        );
      },
    );
  }
}
