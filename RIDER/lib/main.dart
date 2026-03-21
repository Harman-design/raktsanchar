import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/app_colors.dart';
import 'rider/screens/home/home_screen.dart';
import 'rider/screens/auth/login_screen.dart'; // ✅ keep if file is here

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ynncpmsafoijhvfqzkgp.supabase.co',
    anonKey: 'sb_publishable_Su1LMFzGXNx2_fOUUj9J7g_y4WzongA',
  );

  runApp(const RaktsancharRiderApp());
}

class RaktsancharRiderApp extends StatelessWidget {
  const RaktsancharRiderApp({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rider App',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ),

      // 🔐 AUTO LOGIN
      home: session != null ? const HomeScreen() : const LoginScreen(),
    );
  }
}