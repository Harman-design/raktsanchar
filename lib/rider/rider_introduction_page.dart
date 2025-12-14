import 'package:flutter/material.dart';

class RiderIntroductionPage extends StatefulWidget {
  const RiderIntroductionPage({super.key});

  @override
  State<RiderIntroductionPage> createState() => _RiderIntroductionPageState();
}

class _RiderIntroductionPageState extends State<RiderIntroductionPage>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    // navigate to rider login (design unchanged)
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, "/rider-login");
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/logo.png",
                height: 400,
              ),
              const SizedBox(height: 20),
              const Text(
                "Raktsanchar",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "LIFE. DELIVERED. FAST",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
