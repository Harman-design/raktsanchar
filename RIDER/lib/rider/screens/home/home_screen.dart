import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../orders/new_request_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;

  bool loading = true;
  bool isOnline = false;

  String riderName = '';
  String riderId = '';
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardSafe();
  }

  // ================================
  // SAFE DASHBOARD LOADER
  // ================================
  Future<void> _loadDashboardSafe() async {
    try {
      final user = supabase.auth.currentUser!;

      // 1️⃣ PROFILE (safe)
      final profile = await supabase
          .from('profiles')
          .select('id, name')
          .eq('id', user.id)
          .maybeSingle();

      if (profile == null) {
        await supabase.from('profiles').insert({
          'id': user.id,
          'role': 'rider',
        });
      }

      // 2️⃣ RIDER (safe)
      final rider = await supabase
          .from('riders')
          .select('id, is_active')
          .eq('user_id', user.id)
          .maybeSingle();

      if (rider == null) {
        await supabase.from('riders').insert({
          'user_id': user.id,
          'is_active': true,
        });
      }

      // re-fetch guaranteed rows
      final profileRow = await supabase
          .from('profiles')
          .select('name')
          .eq('id', user.id)
          .single();

      final riderRow = await supabase
          .from('riders')
          .select('id, is_active')
          .eq('user_id', user.id)
          .single();

      final ordersData = await supabase
          .from('orders')
          .select(
            'id, requested_type, units_requested, hospitals(name), blood_banks(name)',
          )
          .eq('rider_id', riderRow['id'])
          .eq('status', 'ASSIGNED');

      setState(() {
        riderName = profileRow['name'] ?? '';
        riderId = riderRow['id'];
        isOnline = riderRow['is_active'];
        orders = List<Map<String, dynamic>>.from(ordersData);
        loading = false;
      });
    } catch (e) {
      debugPrint("Dashboard load error: $e");
      setState(() => loading = false);
    }
  }

  // ================================
  // ONLINE TOGGLE
  // ================================
  Future<void> _toggleOnline(bool value) async {
    setState(() => isOnline = value);

    await supabase
        .from('riders')
        .update({'is_active': value}).eq('id', riderId);
  }

  // ================================
  // ACCEPT ORDER
  // ================================
  Future<void> _acceptOrder(String orderId) async {
    await supabase
        .from('orders')
        .update({'status': 'PICKED_UP'}).eq('id', orderId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewRequestScreen(orderId: orderId),
      ),
    );
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
      backgroundColor: const Color(0xFFF5F7F4),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadDashboardSafe,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _header(),
              const SizedBox(height: 16),
              _onlineStatus(),
              const SizedBox(height: 16),
              _statsRow(),
              const SizedBox(height: 24),
              _requestsSection(),
            ],
          ),
        ),
      ),
    );
  }

  // ================================
  // SECTIONS
  // ================================
  Widget _header() {
    return Row(
      children: [
        const CircleAvatar(radius: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Morning, $riderName",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "ID: $riderId",
                style: const TextStyle(color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const Icon(Icons.headset_mic),
      ],
    );
  }

  Widget _onlineStatus() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("You are currently Online",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Ready to receive critical requests",
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Switch(
            value: isOnline,
            activeColor: Colors.green,
            onChanged: _toggleOnline,
          ),
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        Expanded(child: statCard("TRIPS", orders.length.toString(), "Today")),
        const SizedBox(width: 12),
        Expanded(child: statCard("ONLINE", isOnline ? "YES" : "NO", "Status")),
        const SizedBox(width: 12),
        Expanded(child: statCard("EARNINGS", "₹0", "Today")),
      ],
    );
  }

  Widget _requestsSection() {
    if (orders.isEmpty) {
      return const Center(child: Text("No active requests"));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Expanded(
              child: Text(
                "New Requests",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Chip(
              label: Text("URGENT"),
              backgroundColor: Color(0xFFFFE5E5),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...orders.map((o) => _requestCard(o)).toList(),
      ],
    );
  }

  Widget _requestCard(Map<String, dynamic> o) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("CRITICAL",
              style:
                  TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            "${o['requested_type']} • ${o['units_requested']} Units",
            style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Text(
            "Pickup • ${o['blood_banks']['name']}",
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "Drop • ${o['hospitals']['name']}",
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child:
                      const Text("Decline", style: TextStyle(color: Colors.red)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _acceptOrder(o['id']),
                  child: const Text("Accept"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================================
  // COMPONENT
  // ================================
  static Widget statCard(String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 8),
          Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
