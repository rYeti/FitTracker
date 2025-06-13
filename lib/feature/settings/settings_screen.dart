import 'package:fittnes_tracker/core/providers/user_goals_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _calorieGoalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final calorieGoalProvider = Provider.of<UserGoalsProvider>(
      context,
      listen: false,
    );
    _calorieGoalController.text = calorieGoalProvider.calorieGoal.toString();
  }

  @override
  Widget build(BuildContext context) {
    final calorieGoalProvider = Provider.of<UserGoalsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _calorieGoalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Daily Calorie Goal',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final newGoal = int.tryParse(_calorieGoalController.text);
                if (newGoal != null) {
                  calorieGoalProvider.saveCalorieGoal(
                    newGoal,
                  ); // Save to provider
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
