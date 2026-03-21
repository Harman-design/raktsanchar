import 'package:flutter/material.dart';

class OngoingDeliveryPage extends StatefulWidget {
  @override
  _OngoingDeliveryPageState createState() => _OngoingDeliveryPageState();
}

class _OngoingDeliveryPageState extends State<OngoingDeliveryPage> {
  bool isPickedUp = false; // 🔥 main logic

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Ongoing Delivery"),
      ),

      body: isPickedUp
          ? deliveryToUserScreen()
          : riderToBloodBankScreen(),
    );
  }

  // 🔴 SCREEN 1: Rider → Blood Bank
  Widget riderToBloodBankScreen() {
    return Column(
      children: [

        // 🔹 MAP SECTION
        Expanded(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                color: Colors.blue[100],
                child: Center(child: Text("Map to Blood Bank")),
              ),

              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.directions_bike, color: Colors.red),
                ),
              )
            ],
          ),
        ),

        // 🔹 DETAILS CARD
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // TAGS
              Row(
                children: [
                  chip("CRITICAL", Colors.red),
                  SizedBox(width: 8),
                  chip("O- NEGATIVE", Colors.redAccent),
                ],
              ),

              SizedBox(height: 10),

              Text("City Central Blood Bank",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),

              SizedBox(height: 8),

              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 5),
                  Expanded(
                      child: Text(
                          "42nd Medical Drive, Zone 4, Metro City")),
                ],
              ),

              SizedBox(height: 10),

              Row(
                children: [
                  Icon(Icons.phone, color: Colors.red),
                  SizedBox(width: 5),
                  Text("+91 98765-43210"),
                ],
              ),

              SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  // 🔥 SWITCH SCREEN
                  setState(() {
                    isPickedUp = true;
                  });
                },
                child: Text("MARK AS PICKED"),
              ),
            ],
          ),
        )
      ],
    );
  }

  // 🟢 SCREEN 2: Blood Bank → User
  Widget deliveryToUserScreen() {
    return Column(
      children: [

        // 🔹 MAP
        Expanded(
          child: Container(
            width: double.infinity,
            color: Colors.green[100],
            child: Center(child: Text("Map to Delivery Location")),
          ),
        ),

        // 🔹 DETAILS
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("John Doe",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Text("AB-",
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),

              SizedBox(height: 8),

              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey),
                  SizedBox(width: 5),
                  Expanded(
                      child: Text(
                          "City Hospital, Block B, Room 402")),
                ],
              ),

              SizedBox(height: 15),

              Row(
                children: [
                  Expanded(child: infoBox("Payload", "1x Whole Blood")),
                  SizedBox(width: 10),
                  Expanded(child: infoBox("Status", "Priority Transit")),
                ],
              ),

              SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {},
                child: Text("NAVIGATE TO DESTINATION"),
              ),

              SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: Text("REPORT ISSUE"),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      onPressed: () {},
                      child: Text("UPLOAD PROOF"),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  // 🔹 SMALL WIDGETS

  Widget chip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget infoBox(String title, String value) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: Colors.grey)),
          SizedBox(height: 5),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}