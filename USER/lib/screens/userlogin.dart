import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';
import '../user_otp2.dart';
import './user_otp1.dart';

class userLoginPage extends StatefulWidget {
  const userLoginPage({super.key});

  @override
  State<userLoginPage> createState() => _userLoginPageState();
}

class _userLoginPageState extends State<userLoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  // -------------------------
  // OTP SEND LOGIC
  // -------------------------
  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();

    if (phone.length != 10) {
      _showMessage("Enter a valid 10-digit phone number");
      return;
    }

    final formattedPhone = "+91$phone";

    setState(() => _isLoading = true);

    try {
      await supabase.auth.signInWithOtp(phone: formattedPhone);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => userOtpPage(phone: formattedPhone)),
      );
    } on AuthException catch (e) {
      _showMessage(e.message);
    } catch (_) {
      _showMessage("Something went wrong. Try again.");
    }

    setState(() => _isLoading = false);
  }

  // -------------------------
  // UI HELPERS
  // -------------------------
  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
            _buildPhoneInput(),
            const SizedBox(height: 30),
            _buildSendOtpButton(),
            const SizedBox(height: 20),
            _buildFooterText(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // -------------------------
  // WIDGET SECTIONS
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
            "The Pulse of Life, Delivered.",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: const [
        Text(
          "Confirm Your Identity",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          "Enter your phone number to receive a\nverification code",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildPhoneInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.teal.shade300, width: 1.4),
      ),
      child: Row(
        children: [
          Image.asset("assets/india_flag.png", height: 24),
          const SizedBox(width: 8),
          const Text(
            "+91",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: "Enter Phone Number",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendOtpButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _sendOtp,
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
                  "Send Verification Code",
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

  Widget _buildFooterText() {
    return const Text(
      "Your number is secure and used for verification only",
      style: TextStyle(fontSize: 12, color: Colors.grey),
    );
  }
}