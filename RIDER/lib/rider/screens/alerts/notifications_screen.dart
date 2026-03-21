import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _alert("Temperature Warning",
              "Cooler box at 6°C. Check immediately.", AppColors.danger),
          _alert("Urgent: O+ Blood Needed",
              "City Hospital • 4 km away", Colors.redAccent),
          _alert("Traffic Alert",
              "Route updated to save 10 minutes.", Colors.blue),
        ],
      ),
    );
  }

  Widget _alert(String title, String msg, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(msg),
        ],
      ),
    );
  }
}
