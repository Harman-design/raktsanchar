 import 'package:flutter/material.dart';

class DonorNetworkPage extends StatefulWidget {
  const DonorNetworkPage({super.key});

  @override
  State<DonorNetworkPage> createState() => _DonorNetworkPageState();
}

class _DonorNetworkPageState extends State<DonorNetworkPage> {
  String selectedGroup = "All";

  final List<String> bloodGroups = [
    "All", "O-", "A+", "B+", "AB-", "O+"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _mapButton(),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _searchBar(),
            _filterChips(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children:  [
                  Text(
                    "Active Donors (14)",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),

                  DonorCard(
                    name: "Rahul Sharma",
                    bloodGroup: "O- Negative",
                    status: "Available",
                    distance: "1.2 km away",
                    donationInfo: "Donated 4 months ago",
                    badgeText: "Verified Donor",
                    isAvailable: true,
                  ),

                  DonorCard(
                    name: "Anjali Gupta",
                    bloodGroup: "A+ Positive",
                    status: "On Call",
                    distance: "2.8 km away",
                    donationInfo: "Last donation: 6 months ago",
                    badgeText: "Gold Member",
                    isAvailable: true,
                  ),

                  DonorCard(
                    name: "Vikram Singh",
                    bloodGroup: "B+ Positive",
                    status: "Unavailable",
                    distance: "0.5 km away",
                    donationInfo: "Donated 2 weeks ago",
                    badgeText: "Busy until 6:00 PM",
                    isAvailable: false,
                  ),

                  DonorCard(
                    name: "Sana Khan",
                    bloodGroup: "O+ Positive",
                    status: "Available",
                    distance: "4.1 km away",
                    donationInfo: "Donated 3 months ago",
                    badgeText: "Regular Donor",
                    isAvailable: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.arrow_back_ios),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              children: [
                Text("Donor Network",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("City Hospital, Lucknow",
                    style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.notifications_none)
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search by name or locality",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: const Icon(Icons.tune),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _filterChips() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: bloodGroups.length,
        itemBuilder: (context, index) {
          final group = bloodGroups[index];
          final isSelected = group == selectedGroup;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(group),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  selectedGroup = group;
                });
              },
              selectedColor: const Color(0xff1295a1),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _mapButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: () {},
      icon: const Icon(Icons.map),
      label: const Text("Map View"),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 1,
      selectedItemColor: const Color(0xff1295a1),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.hub), label: "Network"),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Requests"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
class DonorCard extends StatelessWidget {
  final String name;
  final String bloodGroup;
  final String status;
  final String distance;
  final String donationInfo;
  final String badgeText;
  final bool isAvailable;

  const DonorCard({
    super.key,
    required this.name,
    required this.bloodGroup,
    required this.status,
    required this.distance,
    required this.donationInfo,
    required this.badgeText,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(bloodGroup,
                style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 6),
            Text(status,
                style: TextStyle(
                    color: isAvailable ? Colors.green : Colors.grey)),
            const SizedBox(height: 6),
            Text(distance),
            const SizedBox(height: 6),
            Text(donationInfo),
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}