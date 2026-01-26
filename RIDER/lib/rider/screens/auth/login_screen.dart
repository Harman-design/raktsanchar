import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../otp_page.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  int selectedVehicle = 0;
  bool loading = false;

  Future<void> sendOtp() async {
    final phone = "+91${mobileController.text.trim()}";

    if (mobileController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid 10-digit mobile number")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      await Supabase.instance.client.auth.signInWithOtp(
        phone: phone,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpPage(phone: phone),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send OTP")),
      );
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔶 TOP BANNER
            SizedBox(
              height: 260,
              width: double.infinity,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFFFD89E),
                          Color(0xFFFFF4E3),
                        ],
                      ),
                    ),
                  ),

                  Center(
                    child: Image.asset(
                      'assets/rider.png',
                      height: 200,
                    ),
                  ),

                  Positioned(
                    top: 16,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.arrow_back, color: Colors.black),
                    ),
                  ),

                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "PARTNER APP",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Welcome, Partner 👋",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 6),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Let's get you set up to start saving lives.",
                style: TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 28),

            // 🔶 VEHICLE
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "I will deliver using",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  vehicleTile(Icons.pedal_bike, "Bike", 0),
                  vehicleTile(Icons.electric_scooter, "Scooter", 1),
                  vehicleTile(Icons.directions_car, "Car", 2),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // 🔶 FULL NAME
            inputLabel("Full Name"),
            inputField(nameController, "e.g. Rahul Sharma", Icons.person),

            const SizedBox(height: 20),

            // 🔶 MOBILE NUMBER
            inputLabel("Mobile Number"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/india_flag.png', height: 16),
                        const SizedBox(width: 6),
                        const Text("+91"),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "9876543210",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "We'll send an OTP for verification.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 28),

            // 🔶 BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 54,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: loading ? null : sendOtp,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Verify & Proceed →",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  "By continuing, you agree to Raktsanchar's\nTerms of Service & Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget vehicleTile(IconData icon, String label, int index) {
    final selected = selectedVehicle == index;

    return GestureDetector(
      onTap: () => setState(() => selectedVehicle = index),
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFEBEB) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? Colors.red : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 6),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget inputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget inputField(TextEditingController controller, String hint, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
