import 'package:ForgeForm/core/app_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/providers/user_goals_provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../widgets/dashboard_weight_card.dart';
import 'package:ForgeForm/l10n/app_localizations.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<String> getScheduledWorkoutNameOrRestDay() async {
    DateTime onlyDate(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
    final db = context.read<AppDatabase>();
    final scheduledWorkoutDao = db.workoutDao;
    final l10n = AppLocalizations.of(context)!;

    final today = onlyDate(DateTime.now());
    final workoutName = await scheduledWorkoutDao.getScheduledWorkoutName(
      today,
    );
    if (workoutName.isNotEmpty) {
      return workoutName;
    } else {
      return l10n.restDay;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goalsProvider = Provider.of<UserGoalsProvider>(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStackGreeting(theme, goalsProvider),
                const SizedBox(height: 16),
                _todayWorkout(theme),
                const SizedBox(height: 16),
                _buildWeightProgress(theme, goalsProvider),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        spacing: 12,
        spaceBetweenChildren: 8,
        overlayOpacity: 0.3,
        overlayColor: Colors.black,
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.restaurant),
            backgroundColor: Colors.orange,
            label: 'Add Breakfast',
            onTap: () async {
              await Navigator.pushNamed(
                context,
                '/add-food',
                arguments: {'category': 'Breakfast'},
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.monitor_weight),
            backgroundColor: Colors.orangeAccent,
            label: 'Add Lunch',
            onTap: () async {
              await Navigator.pushNamed(
                context,
                '/add-food',
                arguments: {'category': 'Lunch'},
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.monitor_weight),
            backgroundColor: Colors.orangeAccent,
            label: 'Add Dinner',
            onTap: () async {
              await Navigator.pushNamed(
                context,
                '/add-food',
                arguments: {'category': 'Dinner'},
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.monitor_weight),
            backgroundColor: Colors.orangeAccent,
            label: 'Add Snack',
            onTap: () async {
              await Navigator.pushNamed(
                context,
                '/add-food',
                arguments: {'category': 'Snack'},
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.monitor_weight),
            backgroundColor: Colors.green,
            label: 'Add Weight',
            onTap: () {
              Navigator.pushNamed(context, '/weight-tracking');
            },
          ),
        ],
      ),
    );
  }

  Future<void> _loadDashboardData() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Widget _buildStackGreeting(ThemeData theme, UserGoalsProvider goalsProvider) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, Alex',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Training with Coach Mike',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Provider.of<ThemeProvider>(context).themeMode ==
                              ThemeMode.light
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    ),
                    onPressed: () {
                      Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      ).toggleTheme();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickStat(
                    theme,
                    Icons.local_fire_department,
                    '350',
                    'Calories',
                    Colors.orange,
                  ),
                  _buildQuickStat(
                    theme,
                    Icons.fitness_center,
                    '3/5',
                    'Workouts',
                    Colors.blue,
                  ),
                  _buildQuickStat(
                    theme,
                    Icons.timer,
                    '45m',
                    'Avg. Time',
                    Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildCaloriesProgress(theme, goalsProvider),
            ],
          ),
        ),
        Positioned(
          left: 24,
          top: 0,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.surface, width: 3),
            ),
            child: CircleAvatar(
              backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
              radius: 24,
              child: Icon(Icons.person, color: theme.colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCaloriesProgress(
    ThemeData theme,
    UserGoalsProvider goalsProvider,
  ) {
    final currentCalories = 2100; // This should come from your nutrition data
    final progress = currentCalories / goalsProvider.dailyCalorieGoal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daily Calories',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$currentCalories / ${goalsProvider.dailyCalorieGoal}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: theme.colorScheme.surfaceVariant,
          valueColor: AlwaysStoppedAnimation<Color>(
            progress > 1.0 ? Colors.red : Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildWeightProgress(
    ThemeData theme,
    UserGoalsProvider goalsProvider,
  ) {
    return DashboardWeightCard(
      goalsProvider: goalsProvider,
      onNavigateToWeightTracking:
          () => Navigator.pushNamed(context, '/weight-tracking'),
    );
  }

  Widget _buildQuickStat(
    ThemeData theme,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _todayWorkout(ThemeData theme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Workout",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder(
              future: getScheduledWorkoutNameOrRestDay(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final workoutName = snapshot.data?.toString() ?? '';
                return Text(
                  workoutName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.secondary,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
