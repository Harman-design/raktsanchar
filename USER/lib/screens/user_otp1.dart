import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart';
import 'user_dashboard1.dart';

class UserOtpPage extends StatefulWidget {
  final String phone;

  const UserOtpPage({
    super.key,
    required this.phone,
  });

  @override
  State<UserOtpPage> createState() => _UserOtpPageState();
}

class _UserOtpPageState extends State<UserOtpPage> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _verifyOtp() async {
    if (_isLoading) return;

    final otp = _otpController.text.trim();

    if (otp.length != 6) {
      _showMessage("Enter a valid 6-digit OTP");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1️⃣ Verify OTP
      await supabase.auth.verifyOTP(
        phone: widget.phone,
        token: otp,
        type: OtpType.sms,
      );

      // 2️⃣ Get authenticated user
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception("User not found");
      }

      // 3️⃣ Create / update user profile
      await supabase.from('profiles').upsert({
        'id': user.id,
        'phone': widget.phone,
        'role': 'user',
      });

      if (!context.mounted) return;

      // 4️⃣ Navigate to Dashboard (FINAL DESTINATION)
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const DashboardPage()),
        (route) => false,
      );
    } on AuthException catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage("Login successful, but profile setup failed");
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 35),
            _buildTitle(),
            const SizedBox(height: 30),
            _buildOtpInput(),
            const SizedBox(height: 30),
            _buildVerifyButton(),
            const SizedBox(height: 20),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ---------------- UI SECTIONS ----------------

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 80, bottom: 40),
      decoration: const BoxDecoration(
        color: Color(0xFF6A1B41),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(80),
          bottomRight: Radius.circular(80),
        ),
      ),
      child: Column(
        children: [
          Image.asset("assets/logo.png", height: 85),
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
            "Verify your number",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        const Text(
          "Enter Verification Code",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          "OTP sent to ${widget.phone}",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildOtpInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.teal.shade300, width: 1.4),
      ),
      child: TextField(
        controller: _otpController,
        keyboardType: TextInputType.number,
        maxLength: 6,
        decoration: const InputDecoration(
          hintText: "Enter OTP",
          counterText: "",
          border: InputBorder.none,
        ),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          letterSpacing: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _verifyOtp,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.teal.shade600,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  "Verify & Continue",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return const Text(
      "Didn’t receive OTP? Wait 60 seconds",
      style: TextStyle(fontSize: 13, color: Colors.grey),
    );
  }
}
