import 'package:flutter/material.dart';

class DeliveryConfirmationPage extends StatefulWidget {
  const DeliveryConfirmationPage({super.key});

  @override
  State<DeliveryConfirmationPage> createState() =>
      _DeliveryConfirmationPageState();
}

class _DeliveryConfirmationPageState
    extends State<DeliveryConfirmationPage> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Delivery Confirmation",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =========================
                  // ARRIVED SECTION
                  // =========================
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE6F4EA),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Arrived at Location",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "City General Hospital, Wing B",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 12),
                  const Text(
                    "Please verify final details and ensure cold chain integrity before completing the handover.",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 24),

                  // =========================
                  // COLD CHAIN
                  // =========================
                  const Text(
                    "Cold Chain Verification",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _infoCard(
                        title: "Final Temp",
                        value: "4.0",
                        suffix: "°C",
                      ),
                      const SizedBox(width: 12),
                      _infoCard(
                        title: "Time",
                        value: "10:42 AM",
                        icon: Icons.access_time,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // =========================
                  // HANDOVER DETAILS
                  // =========================
                  const Text(
                    "Handover Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text("Received By"),
                  const SizedBox(height: 6),
                  TextField(
                    decoration: _inputDecoration("Recipient Full Name"),
                  ),

                  const SizedBox(height: 16),
                  const Text("Role / Designation"),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: _inputDecoration("Select Role"),
                    items: const [
                      DropdownMenuItem(
                        value: "Doctor",
                        child: Text("Doctor"),
                      ),
                      DropdownMenuItem(
                        value: "Nurse",
                        child: Text("Nurse"),
                      ),
                      DropdownMenuItem(
                        value: "Staff",
                        child: Text("Staff"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // =========================
                  // PROOF OF DELIVERY
                  // =========================
                  const Text(
                    "Proof of Delivery",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _proofCard(
                        icon: Icons.edit,
                        title: "Add Signature",
                        subtitle: "Optional",
                      ),
                      const SizedBox(width: 12),
                      _proofCard(
                        icon: Icons.camera_alt,
                        title: "Add Photo",
                        subtitle: "Optional",
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // INFO BOX
                  // =========================
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.info, color: Colors.orange),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Ensure all biological safety protocols are met before leaving the premises.",
                            style: TextStyle(color: Colors.brown),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // =========================
          // CONFIRM BUTTON
          // =========================
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: Text(
                  "Swipe to Confirm",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // REUSABLE WIDGETS
  // =========================
  Widget _infoCard({
    required String title,
    required String value,
    String? suffix,
    IconData? icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4F1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (suffix != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    suffix,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
                if (icon != null) ...[
                  const Spacer(),
                  Icon(icon, color: Colors.grey),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _proofCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFE6F4EA),
              child: Icon(icon, color: const Color(0xFF2E7D32)),
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }
}
