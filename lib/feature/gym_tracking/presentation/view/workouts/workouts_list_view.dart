import 'dart:convert';
import 'package:ForgeForm/core/app_database.dart';
import 'package:ForgeForm/core/di/service_locator.dart';
import 'package:ForgeForm/feature/gym_tracking/presentation/providers/workout_provider.dart';
import 'package:ForgeForm/feature/gym_tracking/presentation/view/workouts/edit_view.dart';
import 'package:ForgeForm/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutsListView extends StatefulWidget {
  const WorkoutsListView();

  @override
  State<WorkoutsListView> createState() => _WorkoutsListViewState();
}

class _WorkoutsListViewState extends State<WorkoutsListView> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.workouts)),
      body: Consumer<WorkoutProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.templates.isEmpty) {
            return Center(child: Text('No workouts found'));
          }

          return ListView.builder(
            itemCount: provider.templates.length,
            itemBuilder: (context, index) {
              final workout = provider.templates[index];

              return ListTile(
                title: Text(workout.name),
                subtitle: Text(
                  '${workout.estimatedDurationMinutes} min • ${workout.difficulty}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditWorkoutView(workoutId: workout.id),
                      ),
                    ).then((_) => provider.loadTemplates());
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

  Future<void> _importCsv() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.single.bytes != null) {
      final file = result.files.single;
      final content = utf8.decode(file.bytes!);

      try {
        final dao = sl<AppDatabase>().workoutDao;
        await dao.importCsvWorkouts(content);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Workouts imported successfully')),
          );
          context.read<WorkoutProvider>().loadTemplates();
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
