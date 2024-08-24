import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkwatch_app/components/drawer.dart';
import 'package:parkwatch_app/dashboard/incidents.dart';
import 'package:parkwatch_app/dashboard/profile.dart';
import 'package:parkwatch_app/parking_info/parking_screen.dart';
import 'package:parkwatch_app/parking_info/parking_service.dart';
import 'package:webview_flutter/webview_flutter.dart';



class ParkWatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ParkWatch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF1759BD),
          secondary: Color(0xFF1759BD),
        ),
      ),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Updated _widgetOptions to include ParkingInfoWidget
  static List<Widget> _widgetOptions = <Widget>[
    ParkingIncidentsReports(),
    ParkingInfoWidget(), // Navigate to ParkingInfoWidget when "Parking Map" is selected
  ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    drawer: CustomDrawer(),
    appBar: AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/icon.png', // Ensure this path is correct
            height: 40,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF1759BD)),
    ),
    body: Container(
      color: Colors.white, // Set the background color of the body to white
      child: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    ),
    bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Parking Info',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Color(0xFF1759BD),
      backgroundColor: Colors.white, // Set background color of BottomNavigationBar
      unselectedItemColor: Colors.black, // Optional: Set color for unselected items
      onTap: _onItemTapped,
    ),
  );
}

}


// ParkingInfoWidget to replace the 'Parking Map' text with actual content




