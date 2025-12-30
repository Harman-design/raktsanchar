import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/user_introduction.dart';
import 'screens/user_login.dart';
import 'screens/user_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ynncpmsafoijhvfqzkgp.supabase.co',
    anonKey: 'sb_publishable_Su1LMFzGXNx2_fOUUj9J7g_y4WzongA',
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const UserAuthGate(),
      routes: {
        '/user/login': (_) => const UserLoginPage(),
        '/user/dashboard': (_) => const UserDashboard(),
      },
    );
  }
}

class UserAuthGate extends StatelessWidget {
  const UserAuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final session = supabase.auth.currentSession;

    if (session != null) {
      return const UserDashboard();
    }

    return const UserIntroductionPage();
  }
}
