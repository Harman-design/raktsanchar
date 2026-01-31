// otp_page.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home/home_screen.dart';

class OtpPage extends StatefulWidget {
  final String phone;
  final String name;
  final int selectedVehicle;

  const OtpPage({
    super.key,
    required this.phone,
    required this.name,
    required this.selectedVehicle,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _otpController = TextEditingController();
  final _supabase = Supabase.instance.client;

  bool _loading = false;

  // ================================
  // MAIN FLOW
  // ================================
  Future<void> _handleVerifyOtp() async {
    if (!_validateOtp()) return;

    _setLoading(true);

    try {
      await _verifyOtp();
      final user = await _waitForSession();
      await _updateProfile(user.id);
      await _updateRider(user.id);

      _showSnack("Login Successful 🎉");
      _goToHome();
    } catch (e) {
      _showSnack(e.toString());
    }

    _setLoading(false);
  }

  // ================================
  // Steps
  // ================================
  Future<void> _verifyOtp() async {
    await _supabase.auth.verifyOTP(
      phone: widget.phone,
      token: _otpController.text.trim(),
      type: OtpType.sms,
    );
  }

  Future<User> _waitForSession() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw "Session not ready. Try again.";
    }

    return user;
  }

  Future<void> _updateProfile(String userId) async {
    await _supabase.from('profiles').update({
      'name': widget.name,
    }).eq('id', userId);
  }

  Future<void> _updateRider(String userId) async {
    await _supabase.from('riders').update({
      'vehicle_number': _vehicleName(widget.selectedVehicle),
    }).eq('user_id', userId);
  }

  // ================================
  // Helpers
  // ================================
  bool _validateOtp() {
    if (_otpController.text.length != 6) {
      _showSnack("Enter valid 6-digit OTP");
      return false;
    }
    return true;
  }

  String _vehicleName(int index) {
    switch (index) {
      case 0:
        return "BIKE";
      case 1:
        return "SCOOTER";
      case 2:
        return "CAR";
      default:
        return "BIKE";
    }
  }

  void _setLoading(bool v) => setState(() => _loading = v);

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  void _goToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (_) => false,
    );
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
            const SizedBox(height: 24),
            _header(),
            _otpInput(),
            const SizedBox(height: 28),
            _verifyButton(),
            const SizedBox(height: 24),
            _footer(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ================================
  // UI Components
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
          Positioned(
            top: 16,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Verify OTP 🔐",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            "OTP sent to ${widget.phone}",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _otpInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: TextField(
        controller: _otpController,
        keyboardType: TextInputType.number,
        maxLength: 6,
        decoration: InputDecoration(
          counterText: "",
          hintText: "Enter 6-digit OTP",
          prefixIcon: const Icon(Icons.lock),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _verifyButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 54,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: _loading ? null : _handleVerifyOtp,
          child: _loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  "Verify OTP & Login",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
        ),
      ),
    );
  }

  Widget _footer() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Text(
          "Didn’t receive OTP? Please wait or try again.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}
