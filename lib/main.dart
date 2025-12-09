
import 'package:flutter/material.dart';
import 'introduction_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const IntroductionPage(),

      routes: {
        "/login": (context) => Scaffold(
          body: Center(child: Text("Login Page Coming Soon")),
        ),
      },
    );
  }
}
