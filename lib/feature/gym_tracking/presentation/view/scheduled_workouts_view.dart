import 'package:fittnes_tracker/core/app_database.dart';
import 'package:fittnes_tracker/feature/gym_tracking/presentation/providers/workout_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scheduled_workout_provider.dart';

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
        final items = provider.scheduled;
        return Scaffold(
          appBar: AppBar(title: const Text('Scheduled Workouts')),
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
                child:
                    items.isEmpty
                        ? const Center(child: Text('No scheduled workouts'))
                        : ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (ctx, idx) {
                            final it = items[idx];
                            return ListTile(
                              title: Text('Workout ${it.workoutId}'),
                              subtitle: Text(it.notes ?? ''),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await provider.removeScheduled(
                                    it.id,
                                    selectedDate,
                                  );
                                },
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              final workoutProvider = context.read<WorkoutProvider>();
              // Ensure templates are loaded
              if (workoutProvider.templates.isEmpty) {
                await workoutProvider.loadTemplates();
              }

              if (workoutProvider.templates.isEmpty) {
                // Show friendly message if no templates
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No workout templates available.'),
                  ),
                );
                return;
              }

              final selected = await showModalBottomSheet<WorkoutTableData>(
                context: context,
                builder: (ctx) {
                  final list = workoutProvider.templates;
                  return ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (ctx, idx) {
                      final t = list[idx];
                      return ListTile(
                        title: Text(t.name),
                        subtitle: Text(t.description ?? ''),
                        onTap: () => Navigator.of(ctx).pop(t),
                      );
                    },
                  );
                },
              );

              if (selected != null) {
                await provider.scheduleWorkout(
                  workoutId: selected.id,
                  scheduledDate: selectedDate,
                  notes: 'Scheduled from template: ${selected.name}',
                );
              }
            },
          ),
        );
      },
    );
  }
}
