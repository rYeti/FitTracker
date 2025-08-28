import 'package:flutter/material.dart';
import 'package:fittnes_tracker/feature/weight_tracking/presentation/widgets/weight_progress_card.dart';
import 'package:fittnes_tracker/core/providers/user_goals_provider.dart';

class DashboardWeightCard extends StatefulWidget {
  final UserGoalsProvider goalsProvider;
  final VoidCallback onNavigateToWeightTracking;

  const DashboardWeightCard({
    Key? key,
    required this.goalsProvider,
    required this.onNavigateToWeightTracking,
  }) : super(key: key);

  @override
  State<DashboardWeightCard> createState() => _DashboardWeightCardState();
}

class _DashboardWeightCardState extends State<DashboardWeightCard> {
  bool _isEditing = false;
  late TextEditingController _startingWeightController;
  late TextEditingController _goalWeightController;
  String? _completionEstimate;

  @override
  void initState() {
    super.initState();
    _startingWeightController = TextEditingController(
      text: widget.goalsProvider.startingWeight.toString(),
    );
    _goalWeightController = TextEditingController(
      text: widget.goalsProvider.goalWeight.toString(),
    );
    _loadCompletionEstimate();
  }

  Future<void> _loadCompletionEstimate() async {
    final estimate = await widget.goalsProvider.getCompletionEstimate();
    if (mounted) {
      setState(() {
        _completionEstimate = estimate;
      });
    }
  }

  @override
  void dispose() {
    _startingWeightController.dispose();
    _goalWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = widget.goalsProvider.getWeightProgress();
    final currentWeight = widget.goalsProvider.currentWeight;
    final goalWeight = widget.goalsProvider.goalWeight;
    final startingWeight = widget.goalsProvider.startingWeight;

    // Update controllers if values change while not editing
    if (!_isEditing) {
      _startingWeightController.text = startingWeight.toString();
      _goalWeightController.text = goalWeight.toString();
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (!_isEditing)
            _buildInfoCard(theme)
          else
            // Edit form for editing mode
            Padding(
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
                  const SizedBox(height: 24),
                  Text('Starting Weight', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _startingWeightController,
                    decoration: const InputDecoration(
                      hintText: 'Enter starting weight',
                      suffixText: 'kg',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Goal Weight', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _goalWeightController,
                    decoration: const InputDecoration(
                      hintText: 'Enter goal weight',
                      suffixText: 'kg',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Dismiss keyboard
                          FocusScope.of(context).unfocus();
                          setState(() {
                            _isEditing = false;
                          });
                        },
                        child: const Text('CANCEL'),
                      ),
                      ElevatedButton(
                        onPressed: _saveWeightGoals,
                        child: const Text('SAVE'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Action buttons overlay (edit button and navigate button)
          Positioned(
            right: 8,
            top: 8,
            child: Row(
              children: [
                // Edit button
                IconButton(
                  icon: Icon(
                    _isEditing ? Icons.close : Icons.edit,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                ),
                // Navigate to weight tracking (only show when not editing)
                if (!_isEditing)
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward,
                      color: theme.colorScheme.primary,
                    ),
                    onPressed: widget.onNavigateToWeightTracking,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _saveWeightGoals() {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    final startingWeight = double.tryParse(_startingWeightController.text);
    final goalWeight = double.tryParse(_goalWeightController.text);

    if (startingWeight == null || goalWeight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid weights')),
      );
      return;
    }

    widget.goalsProvider.setStartingWeight(startingWeight);
    widget.goalsProvider.setGoalWeight(goalWeight);

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Weight goals updated')));

    // Reload the completion estimate after saving
    _loadCompletionEstimate();
  }

  Widget _buildInfoCard(ThemeData theme) {
    return WeightProgressCard(
      currentWeight: widget.goalsProvider.currentWeight,
      startingWeight: widget.goalsProvider.startingWeight,
      goalWeight: widget.goalsProvider.goalWeight,
      progress: widget.goalsProvider.getWeightProgress(),
      completionEstimate: _completionEstimate,
    );
  }
}
