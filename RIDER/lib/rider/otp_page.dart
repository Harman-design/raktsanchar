import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart';
import '../rider/screens/home/home_screen.dart';

class OtpPage extends StatefulWidget {
  final String phone;
  final String fullName;
  final int vehicleType;

  const OtpPage({
    super.key,
    required this.phone,
    required this.fullName,
    required this.vehicleType,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController otpController = TextEditingController();
  bool loading = false;

  // ================================
  // VERIFY OTP + CREATE USER RECORDS
  // ================================
  Future<void> verifyOtp() async {
    if (otpController.text.trim().length < 4) {
      _showSnack("Enter valid OTP");
      return;
    }

    setState(() => loading = true);

    try {
      // 1️⃣ Verify OTP
      final res = await Supabase.instance.client.auth.verifyOTP(
        phone: widget.phone,
        token: otpController.text.trim(),
        type: OtpType.sms,
      );

      final user = res.user;
      if (user == null) throw "User not found";

      final supabase = Supabase.instance.client;

      // 2️⃣ Create / update profile
      await supabase.from('profiles').upsert({
        'id': user.id,
        'name': widget.fullName,
        'phone': widget.phone,
        'role': 'rider',
        'created_at': DateTime.now().toIso8601String(),
      });

      // 3️⃣ Create rider record (if not exists)
      await supabase.from('riders').upsert({
        'user_id': user.id,
        'vehicle_number': _vehicleName(widget.vehicleType),
        'is_active': true,
        'created_at': DateTime.now().toIso8601String(),
      });

      // 4️⃣ Success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful 🎉")),
      );

      // 5️⃣ Go to dashboard
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } catch (e) {
      _showSnack("Invalid OTP or server error");
    }

    setState(() => loading = false);
  }

  // ================================
  // Helpers
  // ================================
  String _vehicleName(int type) {
    switch (type) {
      case 0:
        return "Bike";
      case 1:
        return "Scooter";
      case 2:
        return "Car";
      default:
        return "Bike";
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // ================================
  // UI
  // ================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "OTP sent to ${widget.phone}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : verifyOtp,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Verify & Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
