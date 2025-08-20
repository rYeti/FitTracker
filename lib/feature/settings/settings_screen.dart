import 'package:fittnes_tracker/core/providers/user_goals_provider.dart';
import 'package:fittnes_tracker/core/providers/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _calorieGoalController = TextEditingController();
  bool _initialized = false;
  bool _isSaving = false;
  // Profile inputs (local to the settings screen)
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  Sex _sex = Sex.male;
  ActivityLevel _activity = ActivityLevel.sedentary;
  GoalType _goalType = GoalType.maintenance;

  @override
  void dispose() {
    _calorieGoalController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Load stored profile values (if any) and populate controllers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileFromDb();
    });
  }

  Future<void> _loadProfileFromDb() async {
    try {
      final provider = Provider.of<UserGoalsProvider>(context, listen: false);
      final settings = await provider.db.userSettingsDao.getSettings();
      if (settings != null) {
        // populate controllers and selections
        setState(() {
          _ageController.text = settings.age.toString();
          _heightController.text = settings.heightCm.toString();
          _sex = (settings.sex == 'male') ? Sex.male : Sex.female;
          // guard index bounds
          final activityIndex = settings.activityLevel;
          if (activityIndex >= 0 &&
              activityIndex < ActivityLevel.values.length) {
            _activity = ActivityLevel.values[activityIndex];
          }
          final goalIndex = settings.goalType;
          if (goalIndex >= 0 && goalIndex < GoalType.values.length) {
            _goalType = GoalType.values[goalIndex];
          }
          // Also ensure calorie field reflects persisted value if provider already loaded
          if (provider.isLoaded) {
            _calorieGoalController.text = provider.calorieGoal.toString();
            _initialized = true;
          }
        });
      }
    } catch (_) {
      // ignore load errors, keep defaults
    }
  }

  @override
  Widget build(BuildContext context) {
    final calorieGoalProvider = Provider.of<UserGoalsProvider>(context);
    if (!calorieGoalProvider.isLoaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (!_initialized) {
      _calorieGoalController.text = calorieGoalProvider.calorieGoal.toString();
      _initialized = true;
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile inputs
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Height (cm)'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Sex'),
                const SizedBox(width: 12),
                DropdownButton<Sex>(
                  value: _sex,
                  items:
                      Sex.values
                          .map(
                            (s) =>
                                DropdownMenuItem(value: s, child: Text(s.name)),
                          )
                          .toList(),
                  onChanged: (v) => setState(() => _sex = v ?? Sex.male),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Activity'),
                const SizedBox(width: 12),
                DropdownButton<ActivityLevel>(
                  value: _activity,
                  items:
                      ActivityLevel.values
                          .map(
                            (a) =>
                                DropdownMenuItem(value: a, child: Text(a.name)),
                          )
                          .toList(),
                  onChanged:
                      (v) => setState(
                        () => _activity = v ?? ActivityLevel.sedentary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Goal'),
                const SizedBox(width: 12),
                DropdownButton<GoalType>(
                  value: _goalType,
                  items:
                      GoalType.values
                          .map(
                            (g) =>
                                DropdownMenuItem(value: g, child: Text(g.name)),
                          )
                          .toList(),
                  onChanged:
                      (v) =>
                          setState(() => _goalType = v ?? GoalType.maintenance),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Calorie goal field
            TextField(
              controller: _calorieGoalController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Daily Calorie Goal',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed:
                  _isSaving
                      ? null
                      : () async {
                        // Calculate and save
                        final age = int.tryParse(_ageController.text.trim());
                        final height = int.tryParse(
                          _heightController.text.trim(),
                        );
                        if (age == null || height == null) {
                          if (mounted)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter valid age and height',
                                ),
                              ),
                            );
                          return;
                        }

                        setState(() => _isSaving = true);
                        final provider = Provider.of<UserGoalsProvider>(
                          context,
                          listen: false,
                        );
                        final weightKg = provider.currentWeight;
                        final kcal = provider.calculateCalorieTarget(
                          sex: _sex,
                          age: age,
                          heightCm: height.toDouble(),
                          weightKg: weightKg,
                          activity: _activity,
                          goal: _goalType,
                        );
                        // persist profile + calorie
                        try {
                          await provider.db.userSettingsDao.updateProfile(
                            age: age,
                            heightCm: height,
                            sex: _sex.name,
                            activityLevel: ActivityLevel.values.indexOf(
                              _activity,
                            ),
                            goalType: GoalType.values.indexOf(_goalType),
                          );
                          await provider.saveCalorieGoal(kcal);
                        } catch (e) {
                          if (mounted)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to save profile: $e'),
                              ),
                            );
                        } finally {
                          if (mounted) setState(() => _isSaving = false);
                        }

                        if (!mounted) return;
                        _calorieGoalController.text = kcal.toString();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Calculated and saved calorie goal'),
                          ),
                        );
                        Navigator.pop(context);
                      },
              child:
                  _isSaving
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Text('Calculate & Save'),
            ),

            const SizedBox(height: 12),
            // existing Save button (manual save of the calorie field)
            ElevatedButton(
              onPressed:
                  _isSaving
                      ? null
                      : () async {
                        FocusScope.of(context).unfocus();
                        final text = _calorieGoalController.text.trim();
                        final newGoal = int.tryParse(text);
                        if (newGoal == null) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a valid number'),
                              ),
                            );
                          }
                          return;
                        }

                        setState(() => _isSaving = true);
                        var success = false;
                        try {
                          // Persist profile fields as well (manual save)
                          final age = int.tryParse(_ageController.text.trim());
                          final height = int.tryParse(
                            _heightController.text.trim(),
                          );
                          if (age != null && height != null) {
                            await calorieGoalProvider.db.userSettingsDao
                                .updateProfile(
                                  age: age,
                                  heightCm: height,
                                  sex: _sex.name,
                                  activityLevel: ActivityLevel.values.indexOf(
                                    _activity,
                                  ),
                                  goalType: GoalType.values.indexOf(_goalType),
                                );
                          }

                          await calorieGoalProvider.saveCalorieGoal(newGoal);
                          success = true;
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Failed to update calorie goal: $e',
                                ),
                              ),
                            );
                          }
                        } finally {
                          if (mounted) setState(() => _isSaving = false);
                        }

                        if (success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Calorie goal updated'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
              child:
                  _isSaving
                      ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
