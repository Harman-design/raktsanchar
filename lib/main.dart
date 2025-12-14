// lib/main.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'rider/rider_introduction_page.dart';
import 'rider/screens/rider_login.dart';

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
      home: const RiderLoginPage(),
      routes: {
        "/login": (context) => const RiderLoginPage(),
      },
    );
  }
}
