import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'ongoing_delivery_screen.dart';

class NewRequestScreen extends StatefulWidget {
  final String orderId;

  const NewRequestScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<NewRequestScreen> createState() => _NewRequestScreenState();
}

class _NewRequestScreenState extends State<NewRequestScreen> {
  final supabase = Supabase.instance.client;

  bool loading = true;
  Map<String, dynamic>? order;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  // ================================
  // LOAD ORDER FROM SUPABASE
  // ================================
  Future<void> _loadOrder() async {
    final data = await supabase
        .from('orders')
        .select(
          '''
          id,
          requested_type,
          units_requested,
          status,
          hospitals(name, address),
          blood_banks(name, address)
          ''',
        )
        .eq('id', widget.orderId)
        .single();

    setState(() {
      order = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "New Request",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: _body(),
      bottomNavigationBar: _bottomBar(),
    );
  }

  // ================================
  // BODY
  // ================================
  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _mapSection(),
          _contentSection(),
        ],
      ),
    );
  }

  Widget _mapSection() {
    return Stack(
      children: [
        Image.asset(
          'assets/map.png',
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("ID: ${order!['id'].toString().substring(0, 8)}"),
          ),
        ),
      ],
    );
  }

  Widget _contentSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order!['requested_type'],
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "${order!['units_requested']} Units",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              badge("URGENT REQUEST", Colors.red.shade50, Colors.red),
              const SizedBox(width: 8),
              badge("COLD CHAIN", Colors.blue.shade50, Colors.blue),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            "ROUTE DETAILS",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          routeTile(
            icon: Icons.circle,
            iconColor: Colors.green,
            title: order!['blood_banks']['name'],
            subtitle: order!['blood_banks']['address'] ?? '',
            distance: "Pickup",
          ),

          routeTile(
            icon: Icons.location_on,
            iconColor: Colors.red,
            title: order!['hospitals']['name'],
            subtitle: order!['hospitals']['address'] ?? '',
            distance: "Drop",
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // ================================
  // BOTTOM BAR (FIXED)
  // ================================
  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OngoingDeliveryPage(),
                  ),
                );
              },
              child: const Text("Proceed to Pickup"),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OngoingDeliveryPage(),
                  ),
                );
              },
              child: const Text(
                "Accept Order →",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================
  // HELPERS
  // ================================
  static Widget badge(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child:
          Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
    );
  }

  static Widget routeTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String distance,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(distance,
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                Text(subtitle,
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}