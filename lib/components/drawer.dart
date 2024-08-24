import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkwatch_app/auth_screen/login_screen.dart';
import 'package:parkwatch_app/dashboard/map.dart';

class CustomDrawer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF1759BD),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/profile.jpg'), // Add a profile image here
                ),
                SizedBox(height: 10),
                Text(
                  'Your Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
               
              ],
            ),
          ),
      
          Divider(),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Parking Map'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>MapScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Terms and Conditions'),
            onTap: () {
              // Navigate to Terms and Conditions
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy Policy'),
            onTap: () {
              // Navigate to Privacy Policy
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_mail),
            title: Text('Contact Us'),
            onTap: () {
              // Navigate to Contact Us
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('FAQs'),
            onTap: () {
              // Navigate to FAQs
              Navigator.pop(context);
            },
          ),
          Divider(),
        ListTile(
  leading: Icon(Icons.logout),
  title: Text('Log out'),
  onTap: () async {
    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Sign out from Google
      await GoogleSignIn().signOut();

      // Navigate to the login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>LoginScreen()), // Replace with your actual login screen
      );
    } catch (e) {
      print('Error logging out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging out: $e'),
        ),
      );
    }
  },
),

        ],
      ),
    );
  }
}
