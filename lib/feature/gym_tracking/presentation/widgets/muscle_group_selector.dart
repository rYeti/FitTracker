import 'package:flutter/material.dart';
import 'package:ForgeForm/feature/workout_planning/data/models/exercise.dart';

/// Widget that displays a grid of muscle groups for selection
class MuscleGroupSelector extends StatelessWidget {
  final Function(MuscleGroup) onMuscleGroupSelected;

  const MuscleGroupSelector({Key? key, required this.onMuscleGroupSelected})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      padding: const EdgeInsets.all(16),
      children:
          MuscleGroup.values.map((muscleGroup) {
            return _MuscleGroupCard(
              muscleGroup: muscleGroup,
              onTap: () => onMuscleGroupSelected(muscleGroup),
            );
          }).toList(),
    );
  }
}

class _MuscleGroupCard extends StatelessWidget {
  final MuscleGroup muscleGroup;
  final VoidCallback onTap;

  const _MuscleGroupCard({
    Key? key,
    required this.muscleGroup,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getMuscleGroupIcon(muscleGroup),
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              _getMuscleGroupName(muscleGroup),
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMuscleGroupIcon(MuscleGroup muscleGroup) {
    switch (muscleGroup) {
      case MuscleGroup.chest:
        return Icons.fitness_center;
      case MuscleGroup.back:
        return Icons.accessibility_new;
      case MuscleGroup.shoulders:
        return Icons.sledding;
      case MuscleGroup.biceps:
        return Icons.sports_gymnastics;
      case MuscleGroup.triceps:
        return Icons.sports_martial_arts;
      case MuscleGroup.legs:
        return Icons.directions_run;
      case MuscleGroup.abs:
        return Icons.self_improvement;
      case MuscleGroup.fullBody:
        return Icons.accessibility;
    }
  }

  String _getMuscleGroupName(MuscleGroup muscleGroup) {
    switch (muscleGroup) {
      case MuscleGroup.chest:
        return 'Chest';
      case MuscleGroup.back:
        return 'Back';
      case MuscleGroup.shoulders:
        return 'Shoulders';
      case MuscleGroup.biceps:
        return 'Biceps';
      case MuscleGroup.triceps:
        return 'Triceps';
      case MuscleGroup.legs:
        return 'Legs';
      case MuscleGroup.abs:
        return 'Abs';
      case MuscleGroup.fullBody:
        return 'Full Body';
    }
  }
}
