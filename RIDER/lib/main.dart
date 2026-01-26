import 'package:flutter/material.dart';
import 'core/app_colors.dart';
import 'rider/screens/home/home_screen.dart';
import 'rider/screens/auth/login_screen.dart';


void main() {
  runApp(const RaktsancharRiderApp());
}

class RaktsancharRiderApp extends StatelessWidget {
  const RaktsancharRiderApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      home:  LoginScreen(), // Rider entry screen
    );
  }
}
