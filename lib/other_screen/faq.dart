import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  final Color mainColor = Color(0xFF007BFF); // Replace with your main color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          'About ParkWatch',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About ParkWatch',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 16),
              Text(
                'ParkWatch is an advanced parking management app that simplifies finding and managing parking spaces. It offers real-time data on parking availability, vehicle counts, and customizable alerts. With a user-friendly interface and interactive map, ParkWatch helps users quickly locate available parking spots and provides detailed reports to aid city planners and parking authorities.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
