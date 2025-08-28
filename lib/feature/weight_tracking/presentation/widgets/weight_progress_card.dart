import 'package:flutter/material.dart';

class WeightProgressCard extends StatelessWidget {
  final double currentWeight;
  final double startingWeight;
  final double goalWeight;
  final double progress; // Value between 0.0 and 1.0
  final String? completionEstimate; // Add this parameter

  const WeightProgressCard({
    Key? key,
    required this.currentWeight,
    required this.startingWeight,
    required this.goalWeight,
    required this.progress,
    this.completionEstimate, // Make it optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWeightLoss = startingWeight > goalWeight;
    final weightChange = (currentWeight - startingWeight).abs();
    final remainingWeight = (currentWeight - goalWeight).abs();

    // Determine progress color based on progress and direction
    Color progressColor;
    if (progress <= 0) {
      // Negative or no progress
      progressColor = Colors.red;
    } else if (progress < 0.3) {
      progressColor = Colors.orange;
    } else if (progress < 0.7) {
      progressColor = Colors.yellow;
    } else {
      progressColor = Colors.green;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weight Progress',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Linear progress indicator
            LinearProgressIndicator(
              value: progress,
              backgroundColor: theme.colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 10,
            ),
            const SizedBox(height: 16),

            // Progress stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProgressStat(
                  context,
                  'Starting',
                  '${startingWeight.toStringAsFixed(1)} kg',
                  theme,
                ),
                _buildProgressStat(
                  context,
                  'Current',
                  '${currentWeight.toStringAsFixed(1)} kg',
                  theme,
                  textColor: theme.colorScheme.primary,
                ),
                _buildProgressStat(
                  context,
                  'Goal',
                  '${goalWeight.toStringAsFixed(1)} kg',
                  theme,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Progress details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailItem(
                  context,
                  '${weightChange.toStringAsFixed(1)} kg',
                  isWeightLoss
                      ? (currentWeight < startingWeight ? 'Lost' : 'Gained')
                      : (currentWeight > startingWeight ? 'Gained' : 'Lost'),
                  theme,
                ),
                _buildDetailItem(
                  context,
                  '${remainingWeight.toStringAsFixed(1)} kg',
                  'To Go',
                  theme,
                ),
                _buildDetailItem(
                  context,
                  '${(progress * 100).toStringAsFixed(1)}%',
                  'Complete',
                  theme,
                  valueColor: progressColor,
                ),
              ],
            ),
            // Add completion estimate if available
            if (completionEstimate != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Estimated completion: ',
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text(
                    completionEstimate!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
            // Add warning if moving away from goal
            if ((isWeightLoss && currentWeight > startingWeight) ||
                (!isWeightLoss && currentWeight < startingWeight)) ...{
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(
                    'Moving away from goal',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            },
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStat(
    BuildContext context,
    String label,
    String value,
    ThemeData theme, {
    Color? textColor,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String value,
    String label,
    ThemeData theme, {
    Color? valueColor,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
