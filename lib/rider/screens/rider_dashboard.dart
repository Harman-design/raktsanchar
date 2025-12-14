import 'package:flutter/material.dart';
import '../../main.dart';

class RiderDashboard extends StatelessWidget {
  const RiderDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ❌ Disable back button
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // ❌ remove back arrow
          title: const Text("Rider Dashboard"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await supabase.auth.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
        body: const Center(
          child: Text(
            "Welcome Rider 🚴",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
