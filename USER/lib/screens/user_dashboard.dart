import 'package:flutter/material.dart';
import '../../main.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("User Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await supabase.auth.signOut();
              Navigator.pushReplacementNamed(context, '/user/login');
            },
          )
        ],
      ),
      body: const Center(
        child: Text(
          "Welcome User 🚀",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
