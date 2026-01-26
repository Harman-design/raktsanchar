import 'dart:async';
import 'package:flutter/material.dart';

class EmergencySOSPage extends StatefulWidget {
  const EmergencySOSPage({super.key});

  @override
  State<EmergencySOSPage> createState() => _EmergencySOSPageState();
}

class _EmergencySOSPageState extends State<EmergencySOSPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 0.8,
      upperBound: 1.1,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFDD2727),
      body: SafeArea(
        child: Column(
          children: [
            /// ---------------- TOP BAR ----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      "RAKTSANCHAR",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            /// ---------------- TITLE ----------------
            const SizedBox(height: 20),
            const Text(
              "EMERGENCY\nBLOOD REQUEST",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                height: 1.1,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Alerting nearby donors and emergency blood banks in your vicinity.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ),

            /// ---------------- SOS BUTTON ----------------
            Expanded(
              child: Center(
                child: ScaleTransition(
                  scale: _pulseController,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.4),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(80),
                      onLongPress: () {
                        // TODO: Trigger SOS
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "SOS",
                            style: TextStyle(
                              color: Color(0xFFDD2727),
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "HOLD TO SEND",
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 10,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// ---------------- COUNTDOWN ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _counterBox("0"),
                const SizedBox(width: 8),
                _counterBox("5"),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              "SECONDS TO BROADCAST",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),

            /// ---------------- MAP / BOTTOM SECTION ----------------
            const SizedBox(height: 20),
            Container(
              height: size.height * 0.32,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF8F6F6),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
              child: Stack(
                children: [
                  /// Fake Map Background
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(40),
                      ),
                      color: Colors.grey.shade300,
                    ),
                  ),

                  /// Bottom Card
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFDD2727),
                                ),
                                child: const Icon(
                                  Icons.bloodtype,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ACTIVE COVERAGE",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "12 Donors • 3 Hospitals nearby",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                               onPressed: () {
  Navigator.pushReplacementNamed(context, '/user/dashboard');
},
                                child: const Text(
                                  "CANCEL",
                                  style: TextStyle(
                                    color: Color(0xFFDD2727),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: 0.33,
                            backgroundColor:
                                const Color(0xFFDD2727).withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation(
                              Color(0xFFDD2727),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _counterBox(String value) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white30),
      ),
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
