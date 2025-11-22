import 'package:ForgeForm/core/app_database.dart';
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
  Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ScheduleWorkoutProvider>();
      provider.loadForDate(selectedDate);
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<
    List<
      (
        ExerciseTableData, // The exercise
        List<WorkoutSetTemplateData>, // Templates (plan)
        Map<
          int,
          WorkoutSetTableData
        >, // Previous data: setNumber -> WorkoutSetData
      )
    >
  >
  _loadExercisesForWorkout(int workoutId) async {
    final db = context.read<AppDatabase>();
    final exercises = await db.workoutDao.getWorkoutExercisesWithTemplates(
      workoutId,
    );
    final List<
      (
        ExerciseTableData,
        List<WorkoutSetTemplateData>,
        Map<int, WorkoutSetTableData>,
      )
    >
    result = [];
    for (final exerciseData in exercises) {
      final exercise = exerciseData.$1;
      final templates = exerciseData.$2;

      final previousSets = await db.workoutDao
          .getPreviousWorkoutSetsForExercise(
            exerciseId: exercise.id,
            beforeDate: DateTime.now(),
          );

      // Convert list to map
      final previousSetsMap = {
        for (var set in previousSets) set.setNumber: set,
      };
      result.add((exercise, templates, previousSetsMap));
    }

    return result;
  }

  TextEditingController _getController(
    int exerciseId,
    int setNumber,
    String field,
  ) {
    final key = '${exerciseId}_${setNumber}_$field';
    if (!_controllers.containsKey(key)) {
      _controllers[key] = TextEditingController();
    }
    return _controllers[key]!;
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
                    provider.isRefreshing
                        ? const Center(child: CircularProgressIndicator())
                        : provider.scheduled.isEmpty
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
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Workout header
                                    Row(
                                      children: [
                                        Icon(
                                          isRestDay
                                              ? Icons.hotel
                                              : Icons.fitness_center,
                                          color:
                                              isRestDay
                                                  ? Colors.blue
                                                  : Colors.orange,
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            workout?.name ??
                                                l10n.unknownWorkout,
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleLarge,
                                          ),
                                        ),
                                        if (!isRestDay && workout != null)
                                          Text(
                                            l10n.minutesShort(
                                              workout.estimatedDurationMinutes,
                                            ),
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                          ),
                                      ],
                                    ),
                                    // Exercises list will go here
                                    SizedBox(height: 16),

                                    FutureBuilder(
                                      future: _loadExercisesForWorkout(
                                        workout!.id,
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }

                                        if (snapshot.hasError) {
                                          return Text(
                                            "Error: ${snapshot.error}",
                                          );
                                        }

                                        final exercises = snapshot.data ?? [];

                                        if (exercises.isEmpty) {
                                          return Text(
                                            l10n.noExercisesForWorkout,
                                          );
                                        }

                                        return Column(
                                          children:
                                              exercises.map((exerciseData) {
                                                final exercise =
                                                    exerciseData.$1;
                                                final sets = exerciseData.$2;
                                                final previousSetsMap =
                                                    exerciseData.$3;
                                                return ExpansionTile(
                                                  title: Text(exercise.name),
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child: Text(
                                                                l10n.setLabel,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child: Text(
                                                                l10n.previous,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child: Text(
                                                                l10n.kg,
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child: Text(
                                                                l10n.reps,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        ...sets.map((
                                                          setTemplate,
                                                        ) {
                                                          final previousSet =
                                                              previousSetsMap[setTemplate
                                                                  .setNumber];
                                                          return Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child: Text(
                                                                  '${setTemplate.setNumber}',
                                                                ),
                                                              ),

                                                              // Column 2: Previous (placeholder for now)
                                                              Expanded(
                                                                flex: 2,
                                                                child: Text(
                                                                  '${previousSet?.weight?.toStringAsFixed(0) ?? '--'} kg × ${previousSet?.reps ?? '--'}',
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child: TextField(
                                                                  controller: _getController(
                                                                    exercise.id,
                                                                    setTemplate
                                                                        .setNumber,
                                                                    'weight',
                                                                  ),
                                                                  decoration: InputDecoration(
                                                                    hintText:
                                                                        'Weight',
                                                                    contentPadding:
                                                                        EdgeInsets.all(
                                                                          8,
                                                                        ),
                                                                  ),
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 2,
                                                                child: TextField(
                                                                  controller:
                                                                      _getController(
                                                                        exercise
                                                                            .id,
                                                                        setTemplate
                                                                            .setNumber,
                                                                        'reps',
                                                                      ),
                                                                  decoration: InputDecoration(
                                                                    hintText:
                                                                        'Reps',
                                                                    contentPadding:
                                                                        EdgeInsets.all(
                                                                          8,
                                                                        ),
                                                                  ),
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        }).toList(),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                        );
                                      },
                                    ),
                                  ],
                                ),
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
              // Capture the navigator and provider before showing the bottom sheet
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
                            leading: Icon(Icons.schedule),
                            title: Text(l10n.newWorkout),
                            onTap: () async {
                              // Close the bottom sheet first
                              Navigator.of(bottomSheetContext).pop();
                              // Navigate to CreateWorkoutView using the captured navigator
                              await navigator.push(
                                MaterialPageRoute(
                                  builder: (_) => CreateWorkoutView(),
                                ),
                              );
                              // Refresh the provider after returning
                              provider.refresh();
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
