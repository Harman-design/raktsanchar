import 'package:flutter/material.dart';
import 'package:raktsanchar/services/supabase_service.dart';
import 'user_profile.dart';
import 'user_notifications.dart';
import 'donor_network_page.dart';
import 'dart:async';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int bloodBankCount = 0;
  Map<String, int> inventory = {};
  Map<String, dynamic>? latestOrder;
  bool loading = true;
  bool emergencyOn = true;
  int _currentIndex = 0;
  late final StreamSubscription _subscription;

  final Color primary = const Color(0xFFDE2012);

  @override
  void initState() {
    super.initState();

    fetchDashboardData();

    _subscription = supabase
        .from('blood_units')
        .stream(primaryKey: ['id'])
        .listen((event) {
          fetchDashboardData();
        });
  }

  Future<void> fetchDashboardData() async {
    final banks = await SupabaseService.getBloodBankCount();
    final inv = await SupabaseService.getBloodInventory();
    final order = await SupabaseService.getLatestOrder();

    setState(() {
      bloodBankCount = banks;
      inventory = inv;
      latestOrder = order;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _emergencyCard(),
            _statsSection(),
            _deliveryTracker(),
            _sectionHeader("Blood Components"),
            _bloodGrid(),
            _actionButtons(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _requestBloodButton(),
    );
  }

  // ---------------- APP BAR ----------------
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.bloodtype, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Raktsanchar",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "EMERGENCY NETWORK",
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  color: Color(0xFFDE2012),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.grey),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.grey),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsPage()),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ---------------- EMERGENCY CARD ----------------
  Widget _emergencyCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: primary, width: 2),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: primary.withOpacity(.1),
                  child: Icon(Icons.emergency, color: primary),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Emergency Mode",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Broadcasting Active",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFDE2012),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Switch(
              value: emergencyOn,
              activeColor: Colors.white,
              activeTrackColor: primary,
              onChanged: (v) {
                setState(() => emergencyOn = v);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- STATS ----------------
  Widget _statsSection() {
    return SizedBox(
      height: 120,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: [
          _statCard(
            Icons.local_hospital,
            "Nearby Banks",
            bloodBankCount.toString(),
            null,
          ),
          _statCard(
            Icons.opacity,
            "Live Inventory",
            "84%",
            null,
            iconColor: Colors.blue,
          ),
          _statCard(
            Icons.verified,
            "Last Tested",
            "2h",
            "AGO",
            iconColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    IconData icon,
    String title,
    String value,
    String? extra, {
    Color? color,
    Color? iconColor,
  }) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor ?? primary),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (extra != null)
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    extra,
                    style: TextStyle(
                      fontSize: 12,
                      color: color ?? Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- DELIVERY ----------------
  Widget _deliveryTracker() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.route, color: primary),
                    const SizedBox(width: 6),
                    const Text(
                      "Delivery in progress",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  latestOrder != null
                      ? "#${latestOrder!['id'].toString().substring(0, 6)}"
                      : "No Active Order",
                  style: TextStyle(fontWeight: FontWeight.bold, color: primary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.66,
              minHeight: 6,
              backgroundColor: Colors.grey.shade300,
              color: primary,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- BLOOD GRID ----------------
  Widget _bloodGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: .7,
        children: [
          _BloodCard("RBC", "${inventory["RBC"]} Units", Colors.green),
          _BloodCard("Plasma", "${inventory["Plasma"]} Units", Colors.orange),
          _BloodCard(
            "Platelets",
            "${inventory["Platelets"]} Units",
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            "View Inventory",
            style: TextStyle(color: primary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ---------------- ACTION BUTTONS ----------------
  Widget _actionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _ActionButton(
            Icons.map,
            "Find Donors",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DonorNetworkPage()),
              );
            },
          ),
          _ActionButton(Icons.history, "History", onTap: () {}),
          _ActionButton(Icons.volunteer_activism, "Donate", onTap: () {}),
        ],
      ),
    );
  }

  // ---------------- FAB ----------------
  Widget _requestBloodButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 56),
      child: FloatingActionButton.extended(
        backgroundColor: primary,
        onPressed: () {},
        icon: const Icon(Icons.add_circle),
        label: const Text("Request Blood Now"),
      ),
    );
  }

  // ---------------- BOTTOM NAV ----------------
  Widget _bottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: primary,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        setState(() => _currentIndex = index);
        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Data"),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }

  @override
  void dispose() {
    _subscription.cancel(); // stops the stream
    super.dispose();
  }
}

// ---------------- REUSABLE WIDGETS ----------------

class _BloodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const _BloodCard(this.title, this.subtitle, this.color);

  String get imagePath {
    switch (title) {
      case "RBC":
        return "assets/images/rbc.png";
      case "Plasma":
        return "assets/images/plasma.png";
      case "Platelets":
        return "assets/images/platlets.png";
      default:
        return "assets/logo.png";
    }
  }

  String get statusText => title == "RBC"
      ? "Safe"
      : title == "Plasma"
      ? "Low"
      : "Critical";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton(this.icon, this.label, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
