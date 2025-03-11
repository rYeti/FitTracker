import 'package:flutter/material.dart';
import 'core/di/service_locator.dart';
import 'feature/gym_tracking/view/gym_tracking_screen.dart';
import 'feature/presentation/view/food_tracking_screen.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainScreen());
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [FoodTrackingScreen(), GymTrackingScreen()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant, color: Colors.black),
            label: "Food",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: "Gym",
          ),
        ],
      ),
    );
  }
}
