import 'package:flutter/material.dart';
import 'package:ForgeForm/feature/workout_planning/data/models/exercise.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            muscleGroupIcon(
              muscleGroup,
              size: 96,
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

  Widget muscleGroupIcon(
    MuscleGroup muscleGroup, {
    double size = 48,
    Color? color,
  }) {
    String assetName;
    switch (muscleGroup) {
      case MuscleGroup.chest:
        assetName = 'assets/icons/Chest.png';
        break;
      case MuscleGroup.back:
        assetName = 'assets/icons/back.png';
        break;
      case MuscleGroup.shoulders:
        assetName = 'assets/icons/Shoulder.png';
        break;
      case MuscleGroup.biceps:
        assetName = 'assets/icons/Biceps.png';
        break;
      case MuscleGroup.triceps:
        assetName = 'assets/icons/Triceps.png';
        break;
      case MuscleGroup.legs:
        assetName = 'assets/icons/Hamstrings.png';
        break;
      case MuscleGroup.abs:
        assetName = 'assets/icons/muscles/abs.svg';
        break;
      case MuscleGroup.fullBody:
        assetName = 'assets/icons/muscles/fullbody.svg';
        break;
    }
    // switch (muscleGroup) {
    //   case MuscleGroup.chest:
    //     return const Icon(Icons.fitness_center, size: 48);
    //   case MuscleGroup.back:
    //     return Image.asset(
    //       'assets/icons/muscles/back.png',
    //       width: 48,
    //       height: 48,
    //     );
    //   case MuscleGroup.shoulders:
    //     return const Icon(Icons.sledding, size: 48);
    //   case MuscleGroup.biceps:
    //     return const Icon(Icons.sports_gymnastics, size: 48);
    //   case MuscleGroup.triceps:
    //     return const Icon(Icons.sports_martial_arts, size: 48);
    //   case MuscleGroup.legs:
    //     return const Icon(Icons.directions_run, size: 48);
    //   case MuscleGroup.abs:
    //     return const Icon(Icons.self_improvement, size: 48);
    //   case MuscleGroup.fullBody:
    //     return const Icon(Icons.accessibility, size: 48);
    // }

    return SvgPicture.asset(
      assetName,
      width: size,
      height: size,
      color: color, // dynamically apply the color
    );
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
        return 'Full body';
    }
  }
}
