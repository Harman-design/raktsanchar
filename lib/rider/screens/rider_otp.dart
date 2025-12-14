import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';

class RiderOtpPage extends StatefulWidget {
  final String phone;
  const RiderOtpPage({super.key, required this.phone});

  @override
  State<RiderOtpPage> createState() => _RiderOtpPageState();
}

class _RiderOtpPageState extends State<RiderOtpPage> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  // -------------------------
  // SHOW MESSAGE
  // -------------------------
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // -------------------------
  // VERIFY OTP
  // -------------------------
  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();

    if (otp.length != 6) {
      _showMessage("Enter valid 6-digit OTP");
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

      // 2️⃣ Get logged-in user
      final user = supabase.auth.currentUser;

      if (user == null) {
        _showMessage("Login failed. Try again.");
        return;
      }

      // 3️⃣ INSERT / UPSERT into riders table (THIS IS THE KEY PART)
      await supabase.from('riders').upsert({
        'user_id': user.id,
        'is_active': true,
      });

      if (!mounted) return;

      // 4️⃣ Navigate to Rider Dashboard
      Navigator.pushReplacementNamed(context, '/rider/home');
    } on AuthException catch (e) {
      _showMessage(e.message);
    } catch (e) {
      _showMessage("Invalid OTP or server error");
    }

    setState(() => _isLoading = false);
  }

  // -------------------------
  // UI
  // -------------------------
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

  // -------------------------
  // UI SECTIONS
  // -------------------------
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
