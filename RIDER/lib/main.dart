import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'rider/rider_introduction_page.dart';
import 'rider/screens/rider_login.dart';
import 'rider/screens/rider_dashboard.dart';

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
      home: const AuthGate(),
      routes: {
        '/login': (_) => const RiderLoginPage(),
        '/rider/dashboard': (_) => const RiderDashboard(),
      },
    );
  }
}

/// ---------------------------
/// AUTH GATE
/// ---------------------------
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final session = supabase.auth.currentSession;

    // Already logged in → skip intro
    if (session != null) {
      return const RiderDashboard();
    }

    // Not logged in → show intro
    return const RiderIntroductionPage();
  }
}
