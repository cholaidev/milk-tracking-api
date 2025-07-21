import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Milk Tracking Dashboard')),
      body: Center(child: Text('Welcome to Milk Tracker')),
    );
  }
}
