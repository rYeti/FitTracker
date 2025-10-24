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
              // For now schedule a simple placeholder workout with id=1
              await provider.scheduleWorkout(
                workoutId: 1,
                scheduledDate: selectedDate,
                notes: 'Added from UI',
              );
            },
          ),
        );
      },
    );
  }
}
