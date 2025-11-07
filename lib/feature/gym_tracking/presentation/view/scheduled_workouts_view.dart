import 'package:ForgeForm/feature/gym_tracking/presentation/providers/workout_provider.dart';
import 'package:ForgeForm/feature/gym_tracking/presentation/view/workouts/create_view.dart';
import 'package:ForgeForm/feature/gym_tracking/presentation/view/workouts/workouts_list_view.dart';
import 'package:ForgeForm/l10n/app_localizations.dart';
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
  int _rebuildKey = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ScheduleWorkoutProvider>();
      print('Loading workouts for date: $selectedDate');
      provider.loadForDate(selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<ScheduleWorkoutProvider>(
      key: ValueKey(_rebuildKey),
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.workouts),
            actions: [
              IconButton(
                tooltip: l10n.seedWorkoutTemplates,
                icon: const Icon(Icons.file_download),
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.seedingTemplates)),
                  );
                  try {} catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.seedingFailed(e))),
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
                child:
                    provider.scheduled.isEmpty
                        ? Center(child: Text(l10n.noScheduledWorkouts))
                        : ListView.builder(
                          itemCount: provider.scheduled.length,
                          itemBuilder: (context, index) {
                            final item = provider.scheduled[index];
                            final workout = item.workout;
                            final isRestDay = workout?.name == 'Rest Day';

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: ListTile(
                                leading: Icon(
                                  isRestDay
                                      ? Icons.hotel
                                      : Icons.fitness_center,
                                  color:
                                      isRestDay ? Colors.blue : Colors.orange,
                                ),
                                title: Text(
                                  workout?.name ?? l10n.unknownWorkout,
                                ),
                                subtitle:
                                    item.scheduled.notes != null
                                        ? Text(item.scheduled.notes!)
                                        : null,
                                trailing:
                                    !isRestDay && workout != null
                                        ? Text(
                                          l10n.minutesShort(
                                            workout.estimatedDurationMinutes,
                                          ),
                                        )
                                        : null,
                                onTap:
                                    !isRestDay
                                        ? () {
                                          // TODO: Navigate to workout details
                                        }
                                        : null,
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: l10n.createOrEditWorkouts,
            child: const Icon(Icons.add),
            onPressed: () async {
              // Capture the navigator before showing the bottom sheet
              final navigator = Navigator.of(context);
              showModalBottomSheet(
                context: context,
                builder:
                    (bottomSheetContext) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Icons.schedule),
                            title: Text(l10n.newWorkout),
                            onTap: () {
                              // Close the bottom sheet first
                              Navigator.of(bottomSheetContext).pop();
                              // Navigate to CreateWorkoutView using the captured navigator
                              navigator.push(
                                MaterialPageRoute(
                                  builder: (_) => CreateWorkoutView(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.remove_red_eye),
                            title: Text(l10n.viewWorkouts),
                            onTap: () async {
                              final result = await Navigator.of(context).push(
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
              setState(() => _rebuildKey++);
            },
          ),
        );
      },
    );
  }
}
