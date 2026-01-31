import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/app_colors.dart';
import '../../widgets/primary_button.dart';
import 'ongoing_delivery_screen.dart';

class PickupScreen extends StatefulWidget {
  final String orderId;

  const PickupScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  final supabase = Supabase.instance.client;

  bool loading = true;
  Map<String, dynamic>? order;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  // ================================
  // LOAD ORDER DATA
  // ================================
  Future<void> _loadOrder() async {
    try {
      final data = await supabase
          .from('orders')
          .select('''
            id,
            requested_type,
            units_requested,
            blood_banks(name, address),
            hospitals(name, address)
          ''')
          .eq('id', widget.orderId)
          .single();

      setState(() {
        order = data;
        loading = false;
      });
    } catch (e) {
      _showSnack("Failed to load order");
      loading = false;
    }
  }

  // ================================
  // CONFIRM PICKUP
  // ================================
  Future<void> _confirmPickup() async {
    await supabase.from('orders').update({
      'status': 'PICKED_UP',
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', widget.orderId);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OngoingDeliveryScreen(orderId: widget.orderId),
      ),
    );
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
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "Pickup Confirmation",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _verifiedIcon(),
          const SizedBox(height: 20),
          _title(),
          const SizedBox(height: 32),
          _summaryHeader(),
          const SizedBox(height: 12),
          _bloodCard(),
          const SizedBox(height: 16),
          _bloodBankCard(),
          const SizedBox(height: 28),
          _verification(),
          const SizedBox(height: 28),
          PrimaryButton(
            text: "Start Delivery",
            onTap: _confirmPickup,
          ),
        ],
      ),
    );
  }

  // ================================
  // SECTIONS
  // ================================
  Widget _verifiedIcon() {
    return Center(
      child: Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withOpacity(0.12),
        ),
        child: const Center(
          child: CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.check, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return Column(
      children: [
        const Center(
          child: Text(
            "Pickup Verified",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            "Order ID: ${widget.orderId}",
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _summaryHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Order Summary",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            TimeOfDay.now().format(context),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _bloodCard() {
    return _infoCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "BLOOD COMPONENT",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  order!['requested_type'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${order!['units_requested']} Units • standard bag",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.red.shade100,
            ),
            child: const Icon(Icons.bloodtype, color: Colors.red, size: 40),
          ),
        ],
      ),
    );
  }

  Widget _bloodBankCard() {
    return _infoCard(
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Icon(Icons.add, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order!['blood_banks']['name'],
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  order!['blood_banks']['address'] ?? '',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const Icon(Icons.map_outlined),
        ],
      ),
    );
  }

  Widget _verification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Verification",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Center(
            child: Text("Tap to sign", style: TextStyle(color: Colors.grey)),
          ),
        ),
      ],
    );
  }

  // ================================
  // HELPER
  // ================================
  Widget _infoCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class OngoingDeliveryScreen extends StatelessWidget {
  final String orderId;

  const OngoingDeliveryScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ongoing Delivery")),
      body: Center(
        child: Text("Delivering Order: $orderId"),
      ),
    );
  }
}
