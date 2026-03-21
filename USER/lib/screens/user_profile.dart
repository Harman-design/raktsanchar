import 'package:flutter/material.dart';
import '../services/supabase_client.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      setState(() => loading = false);
      return;
    }

    final data = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .single();

    setState(() {
      userData = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFCF2C20);

    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Edit",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: _bottomNav(primaryColor),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Profile Image + Name
            Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuBqgoyln87Drpn5eqVtJ7kMDYmVWgiTkPZ-Ttc_kr-V5-A6u-pmww5rKOkEU0DhgT7HwlFR6ssrHZPZysttlywT3bhi9vvmU3-mFY7GtcSKcWqfXyoy7mNVOvQC0heRZGyIprYNX6Ly3SCDk6odScFJV-fz6e7-6rPzhnFotIax48rtRpct8y7ZpH8MlL32Me9DtAZXosbkPOlxzMForpyua7pjPC5hESp5uMtpFC9zOUOf3RQpEnNuFm7zZJhQiqqKq-zOjGqyiQQD",
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: primaryColor,
                        child: const Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  userData?['name'] ?? "No Name",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Verified Donor • Member since 2023",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _StatCard(title: "Blood", value: "O+", highlight: true),
                _StatCard(title: "Age", value: "28"),
                _StatCard(title: "Weight", value: "74kg"),
              ],
            ),

            const SizedBox(height: 28),

            /// Personal Details
            _sectionTitle("Personal Details"),
            _infoTile(Icons.mail, "Email", userData?['email'] ?? "No Email"),
            _infoTile(Icons.call, "Phone", userData?['phone'] ?? "No Phone"),

            const SizedBox(height: 28),

            /// Emergency Contacts
            _sectionTitle("Emergency Contacts"),
            _contactTile("Anita Sharma", "Mother"),
            _contactTile("Rahul Varma", "Brother"),

            const SizedBox(height: 28),

            /// Medical Notes
            _sectionTitle("Medical Notes"),
            _medicalBox(
              icon: Icons.info,
              title: "Known Allergies",
              text:
                  "No allergies listed. Please consult your physician before emergency donation.",
            ),
            _medicalBox(
              icon: Icons.medical_services,
              title: "Conditions",
              text: "No chronic health conditions reported.",
            ),

            const SizedBox(height: 28),

            /// Logout
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () async {
                await supabase.auth.signOut();

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/user/login', // your login route
                  (route) => false,
                );
              },
              child: const Text(
                "Logout",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),
            const Text(
              "Raktsanchar v2.4.0",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ----------------- Widgets -----------------

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final bool highlight;

  const _StatCard({
    required this.title,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight
            ? const Color(0xFFCF2C20).withOpacity(0.1)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: highlight ? const Color(0xFFCF2C20) : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _sectionTitle(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
}

Widget _infoTile(IconData icon, String label, String value) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon, color: Colors.grey),
    title: Text(
      label,
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    ),
    subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
  );
}

Widget _contactTile(String name, String relation) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.black12,
        child: Icon(Icons.person),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(relation),
      trailing: const CircleAvatar(
        backgroundColor: Color(0xFFCF2C20),
        child: Icon(Icons.call, color: Colors.white),
      ),
    ),
  );
}

Widget _medicalBox({
  required IconData icon,
  required String title,
  required String text,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFFCF2C20)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(text, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _bottomNav(Color primaryColor) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: primaryColor,
    unselectedItemColor: Colors.grey,
    currentIndex: 4,
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.search), label: "Find"),
      BottomNavigationBarItem(icon: Icon(Icons.bloodtype), label: "Request"),
      BottomNavigationBarItem(icon: Icon(Icons.history), label: "Activity"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
    ],
  );
}
