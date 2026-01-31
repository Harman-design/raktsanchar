import 'package:flutter/material.dart';
import 'pickup_screen.dart';

class NewRequestScreen extends StatelessWidget {
  const NewRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🗺️ MAP IMAGE
            Stack(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text("ID: #REQ-8922"),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔴 TITLE
                  const Text(
                    "O+ Whole Blood",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "2 Units • Standard Pack",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 12),

                  // 🔖 BADGES
                  Row(
                    children: [
                      badge("URGENT REQUEST",
                          Colors.red.shade50, Colors.red),
                      const SizedBox(width: 8),
                      badge("COLD CHAIN",
                          Colors.blue.shade50, Colors.blue),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 💰 PAY + TIME
                  Row(
                    children: [
                      infoCard("EST. PAY", "₹150"),
                      const SizedBox(width: 12),
                      infoCard("EST. TIME", "25 min"),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 📍 ROUTE DETAILS
                  const Text(
                    "ROUTE DETAILS",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),

                  routeTile(
                    icon: Icons.circle,
                    iconColor: Colors.green,
                    title: "City General Hospital",
                    subtitle: "42 Green Avenue, Block C",
                    distance: "2.5 km",
                  ),

                  routeTile(
                    icon: Icons.location_on,
                    iconColor: Colors.red,
                    title: "St. Mary's Trauma Center",
                    subtitle: "88 Health Park Road",
                    distance: "5.0 km",
                  ),

                  const SizedBox(height: 12),

                  // ⚠️ NOTE
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3CD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Handover directly to ER reception. Do not leave at front desk.",
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),

      // 🔴 BOTTOM BUTTONS
      bottomNavigationBar: Container(
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
            // 🟢 PROCEED TO PICKUP
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PickupScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Proceed to Pickup"),
              ),
            ),

            const SizedBox(width: 12),

            // 🔴 ACCEPT ORDER
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PickupScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Accept Order →",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 HELPERS
  static Widget badge(String text, Color bg, Color fg) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: fg, fontWeight: FontWeight.bold),
      ),
    );
  }

  static Widget infoCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      distance,
                      style:
                          const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Text(
                  subtitle,
                  style:
                      const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
