import 'package:flutter/material.dart';
import 'rider/rider_introduction_page.dart';
import 'rider/screens/rider_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RiderIntroductionPage(),
      routes: {
        "/rider-login": (context) => const RiderLoginPage(),
      },
    );
  }
}
