import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class PickupScreen extends StatelessWidget {
  PickupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pickup"),
      ),
      body: const Center(
        child: Text("Pickup Screen"),
      ),
    );
  }
}
