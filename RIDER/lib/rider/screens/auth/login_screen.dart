// login_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'otp_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ================================
  // Controllers & State
  // ================================
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  int selectedVehicle = 0;
  bool loading = false;

  // ================================
  // Send OTP
  // ================================
  Future<void> sendOtp() async {
    if (!_validateInput()) return;

    final phone = "+91${mobileController.text.trim()}";
    setState(() => loading = true);

    try {
      await Supabase.instance.client.auth.signInWithOtp(phone: phone);

      // 👉 Pass name & vehicle to OTP page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpPage(
            phone: phone,
            name: nameController.text.trim(),
            selectedVehicle: selectedVehicle,
          ),
        ),
      );
    } catch (e) {
      _showSnack("Failed to send OTP. Try again.");
    }

    setState(() => loading = false);
  }

  // ================================
  // Validation
  // ================================
  bool _validateInput() {
    if (nameController.text.trim().isEmpty) {
      _showSnack("Enter your full name");
      return false;
    }

    if (mobileController.text.trim().length != 10) {
      _showSnack("Enter valid 10-digit mobile number");
      return false;
    }

    return true;
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ================================
  // UI
  // ================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topBanner(),
            _header(),
            _vehicleSection(),
            _nameInput(),
            _mobileInput(),
            _submitButton(),
            _termsText(),
          ],
        ),
      ),
    );
  }

  // ================================
  // Widgets
  // ================================

  Widget _topBanner() {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFD89E), Color(0xFFFFF4E3)],
              ),
            ),
          ),
          Center(child: Image.asset('assets/rider.png', height: 200)),
          const Positioned(
            top: 16,
            right: 16,
            child: Chip(
              label: Text(
                "PARTNER APP",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome, Partner 👋",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text("Let's get you set up to start saving lives.",
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _vehicleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("I will deliver using",
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              vehicleTile(Icons.pedal_bike, "Bike", 0),
              vehicleTile(Icons.electric_scooter, "Scooter", 1),
              vehicleTile(Icons.directions_car, "Car", 2),
            ],
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _nameInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        inputLabel("Full Name"),
        inputField(nameController, "e.g. Rahul Sharma", Icons.person),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _mobileInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        inputLabel("Mobile Number"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _countryCode(),
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Text(
            "We'll send an OTP for verification.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SizedBox(
        height: 54,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
    );
  }

  Widget _termsText() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Text(
          "By continuing, you agree to Raktsanchar's\nTerms of Service & Privacy Policy.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _countryCode() {
    return Container(
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
    );
  }

  // ================================
  // Reusable Components
  // ================================

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

  Widget inputField(
      TextEditingController controller, String hint, IconData icon) {
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
