
import 'package:ForgeForm/core/app_database.dart';
import 'package:ForgeForm/feature/gym_tracking/presentation/providers/workout_provider.dart';
import 'package:ForgeForm/feature/gym_tracking/presentation/view/workouts/create_view.dart';
import 'package:ForgeForm/feature/gym_tracking/presentation/view/workouts/workouts_list_view.dart';
import 'package:ForgeForm/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scheduled_workout_provider.dart'; // Import the new ActiveWorkoutScreen
import 'workouts/active_workout_view.dart';

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
                },
              ),
              IconButton(
                tooltip: 'Manage Workouts',
                icon: const Icon(Icons.list),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WorkoutsListView()),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              // Date selector
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
                      onPressed: () => provider.refresh(),
                    ),
                  ],
                ),
              ), // Workout list
              Expanded(
                child:
                    provider.isRefreshing
                        ? const Center(child: CircularProgressIndicator())
                        : provider.scheduled.isEmpty
                        ? Center(child: Text(l10n.noScheduledWorkouts))
                        : ListView.builder(
                          itemCount: provider.scheduled.length,
                          itemBuilder: (context, index) {
                            final item = provider.scheduled[index];
                            return _buildWorkoutCard(item, context);
                          },
                        ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: l10n.createOrEditWorkouts,
            child: const Icon(Icons.add),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final provider = context.read<ScheduleWorkoutProvider>();
              showModalBottomSheet(
                context: context,
                builder:
                    (bottomSheetContext) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.schedule),
                            title: Text(l10n.newWorkout),
                            onTap: () async {
                              Navigator.of(bottomSheetContext).pop();
                              await navigator.push(
                                MaterialPageRoute(
                                  builder: (_) => CreateWorkoutView(),
                                ),
                              );
                              provider.refresh();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.remove_red_eye),
                            title: Text(l10n.viewWorkouts),
                            onTap: () async {
                              Navigator.of(bottomSheetContext).pop();
                              final result = await navigator.push(
                                MaterialPageRoute(
                                  builder: (_) => WorkoutsListView(),
                                ),
                              );
                              if (result == true) {
                                context.read<WorkoutProvider>().loadTemplates();
                                provider.refresh();
                                setState(() => _rebuildKey++);
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

  Widget _buildWorkoutCard(
    ScheduledWorkoutWithDetails item,
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final workout = item.workout;
    final isRestDay = workout?.name == 'Rest Day';
    final isCompleted = item.scheduled.isCompleted;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color:
          isCompleted
              ? theme.colorScheme.surfaceVariant.withOpacity(0.5)
              : null,
      child: InkWell(
        onTap: isRestDay || isCompleted ? null : () => _startWorkout(item),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isRestDay ? Icons.hotel : Icons.fitness_center,
                    color: isRestDay ? Colors.blue : Colors.orange,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout?.name ?? l10n.unknownWorkout,
                          style: theme.textTheme.titleLarge?.copyWith(
                            decoration:
                                isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        if (!isRestDay && workout != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            l10n.minutesShort(workout.estimatedDurationMinutes),
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (isCompleted)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 32,
                    )
                  else if (!isRestDay)
                    const Icon(Icons.play_arrow, size: 32),
                ],
              ),
              if (item.scheduled.notes != null &&
                  item.scheduled.notes!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.note, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.scheduled.notes!,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (!isRestDay && !isCompleted) ...[
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _startWorkout(item),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Workout'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Navigate to the new ActiveWorkoutScreen
  Future<void> _startWorkout(ScheduledWorkoutWithDetails item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            ( context) => ActiveWorkoutScreen(
              scheduledWorkout: item,
              scheduledDate: selectedDate,
            ),
      ),
    ); // Refresh the list if the workout was completed
    if (result == true) {
      final provider = context.read<ScheduleWorkoutProvider>();
      provider.refresh();
    }
  }
}
