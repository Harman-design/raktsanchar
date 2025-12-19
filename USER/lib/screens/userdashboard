import 'package:flutter/material.dart';
import '../../main.dart';

class userDashboard extends StatelessWidget {
  const userDashboard({super.key});

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
          title: const Text("user Dashboard"),
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
            "Welcome user 🚴",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
