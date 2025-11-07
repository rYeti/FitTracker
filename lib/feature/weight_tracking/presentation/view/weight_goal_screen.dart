import 'package:ForgeForm/core/providers/user_goals_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeightGoalScreen extends StatefulWidget {
  const WeightGoalScreen({Key? key}) : super(key: key);

  @override
  _WeightGoalScreenState createState() => _WeightGoalScreenState();
}

class _WeightGoalScreenState extends State<WeightGoalScreen> {
  late TextEditingController _startingWeightController;
  late TextEditingController _goalWeightController;
  late UserGoalsProvider _goalsProvider;
  String? _completionEstimate;

  @override
  void initState() {
    super.initState();
    _goalsProvider = Provider.of<UserGoalsProvider>(context, listen: false);
    _startingWeightController = TextEditingController(
      text: _goalsProvider.startingWeight.toString(),
    );
    _goalWeightController = TextEditingController(
      text: _goalsProvider.goalWeight.toString(),
    );
    _loadCompletionEstimate();
  }

  Future<void> _loadCompletionEstimate() async {
    final estimate = await _goalsProvider.getCompletionEstimate();
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

    return Scaffold(
      appBar: AppBar(title: const Text('Weight Goals')),
      body: Consumer<UserGoalsProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Starting Weight',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _startingWeightController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your starting weight (kg)',
                    suffixText: 'kg',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Goal Weight',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _goalWeightController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your goal weight (kg)',
                    suffixText: 'kg',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveWeightGoals,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Save Weight Goals'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _saveWeightGoals() {
    final startingWeight = double.tryParse(_startingWeightController.text);
    final goalWeight = double.tryParse(_goalWeightController.text);

    if (startingWeight == null || goalWeight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid weights')),
      );
      return;
    }

    _goalsProvider.setStartingWeight(startingWeight);
    _goalsProvider.setGoalWeight(goalWeight);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Weight goals saved')));

    Navigator.pop(context);
  }
}
