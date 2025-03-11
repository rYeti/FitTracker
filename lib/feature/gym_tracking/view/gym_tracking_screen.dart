import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GymTrackingScreen extends StatefulWidget {
  const GymTrackingScreen({super.key});

  @override
  _GymTrackingScreen createState() => _GymTrackingScreen();
}

class _GymTrackingScreen extends State<GymTrackingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Gym Screen Loaded!")));
  }
}
