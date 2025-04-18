import 'dart:ui';

import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Dashboard')));
  }

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _LoadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    // ... existing code
    return Scaffold(
      // ... existing code
      body: RefreshIndicator(
        onRefresh: _LoadDashboardData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStackGreeting(),
                const SizedBox(height: 16),
                _todayWorkout(),
                const SizedBox(height: 16),
                // ... rest of your widgets
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _LoadDashboardData() async {
    setState(() => _isLoading = true);

    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildStackGreeting() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 12), // Space for the avatar overlap
          padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20), // Space for avatar overlap
              Text(
                'Hi, Alex',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Training with Coach Mike',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Positioned(
          left: 24,
          top: 0,
          child: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            radius: 24,
            child: Icon(Icons.person, color: Colors.blue.shade800),
          ),
        ),
      ],
    );
  }

  Widget _todayWorkout() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text('Today Workout'),
      ),
    );
  }
}
