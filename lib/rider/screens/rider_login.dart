import 'package:flutter/material.dart';

class RiderLoginPage extends StatefulWidget {
  const RiderLoginPage({super.key});

  @override
  State<RiderLoginPage> createState() => _RiderLoginPageState();
}

class _RiderLoginPageState extends State<RiderLoginPage> {
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [

            // 🔵 TOP CURVED CONTAINER
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF6A1B41), // deep maroon like your UI
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80),
                ),
              ),
              padding: const EdgeInsets.only(top: 80, bottom: 40),
              child: Column(
                children: [
                  // Logo (Replace asset)
                  Image.asset(
                    "assets/logo.png",
                    height: 85,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Raktsanchar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "The Pulse of Life, Delivered.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // Title
            const Text(
              "Confirm Your Identity",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Enter your phone number to receive to\nverification code",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            // PHONE NUMBER FIELD
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.teal.shade300, width: 1.4),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/india_flag.png", // add this if needed
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "+91",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: "Enter Phone Number",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // SEND OTP BUTTON
            GestureDetector(
              onTap: () {
                // TODO: Rider OTP screen navigation
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.teal.shade600,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    "Send Verification Code",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Your number is secure and used & verification only",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
