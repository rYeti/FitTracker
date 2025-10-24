import 'package:fittnes_tracker/core/app_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/service_locator.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/user_goals_provider.dart';
import 'feature/weight_tracking/presentation/providers/weight_provider.dart';
import 'feature/food_tracking/data/repositories/meal_template_repository.dart';
import 'feature/gym_tracking/presentation/view/gym_tracking_screen.dart';
import 'feature/food_tracking/presentation/view/food_tracking_screen.dart';
import 'feature/food_tracking/presentation/view/nutrition_progress_dashboard.dart';
import 'feature/dashboard/view/dashboard_screen.dart';
import 'feature/food_tracking/presentation/view/food_add_screen.dart';
import 'feature/settings/settings_screen.dart';
import 'feature/weight_tracking/presentation/view/weight_tracking_screen.dart';
import 'feature/weight_tracking/presentation/view/weight_goal_screen.dart';
import 'feature/food_tracking/presentation/view/meal_templates_screen.dart';
import 'package:fittnes_tracker/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  setupLocator();
  final db = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        // Provide the AppDatabase instance directly
        Provider<AppDatabase>.value(value: db),
        ChangeNotifierProvider(create: (_) => ThemeProvider(db)),
        ChangeNotifierProvider(create: (_) => UserGoalsProvider(db)),
        ChangeNotifierProxyProvider<UserGoalsProvider, WeightProvider>(
          create:
              (context) => WeightProvider(
                db,
                userGoalsProvider: Provider.of<UserGoalsProvider>(
                  context,
                  listen: false,
                ),
              ),
          update:
              (context, userGoalsProvider, weightProvider) =>
                  weightProvider ??
                  WeightProvider(db, userGoalsProvider: userGoalsProvider),
        ),
        Provider<MealTemplateRepository>(
          create: (_) => MealTemplateRepository(db),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('de')],
      theme: themeProvider.lightTheme,
      darkTheme: themeProvider.darkTheme,
      themeMode: themeProvider.themeMode,
      title: 'FitTracker',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/add-food') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => FoodAddScreen(category: args['category']),
          );
        }

        if (settings.name == '/dashboard') {
          return MaterialPageRoute(builder: (_) => const DashboardScreen());
        }

        if (settings.name == '/settings') {
          return MaterialPageRoute(builder: (_) => const SettingsScreen());
        }

        if (settings.name == '/weight-tracking') {
          return MaterialPageRoute(
            builder: (_) => const WeightTrackingScreen(),
          );
        }

        if (settings.name == '/weight-goals') {
          return MaterialPageRoute(builder: (_) => const WeightGoalScreen());
        }

        if (settings.name == '/meal-templates') {
          return MaterialPageRoute(builder: (_) => const MealTemplatesScreen());
        }

        return MaterialPageRoute(builder: (_) => const HomeScreen());
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    FoodTrackingScreen(key: globalFoodTrackingKey),
    const GymTrackingScreen(),
    const NutritionProgressDashboard(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _screens),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          backgroundColor: Theme.of(context).colorScheme.surface,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard),
              label: AppLocalizations.of(context)!.dashboard,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              label: AppLocalizations.of(context)!.food,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: AppLocalizations.of(context)!.gym,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: AppLocalizations.of(context)!.progress,
            ),
          ],
        ),
      ),
    );
  }
}
