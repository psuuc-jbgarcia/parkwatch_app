import 'package:flutter/material.dart';
import 'package:parkwatch_app/auth_screen/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            Image.asset('assets/logo.png', height: 120), // Replace with your logo asset
            SizedBox(height: 20),
            Text(
              'ParkWatch',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              'Your Parking Peace of Mind',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Username or E-mail',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Handle forgot password
                      },
                      child: Text('Forgot Password?'),
                    ),
                  ),
                  SizedBox(height: 20),
                        ElevatedButton(
  onPressed: () {
    // Handle login
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF1759BD), // Set button color to #1759BD
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
  ),
  child: Text('Log In',style: TextStyle(
    color: Colors.white
  ),),
),
                  SizedBox(height: 20),
                  Text('Or continue with'),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Image.asset('assets/google_icon.png'), // Replace with your Google icon asset
                        onPressed: () {
                          // Handle Google login
                        },
                      ),
                      IconButton(
                        icon: Image.asset('assets/facebook_icon.png'), // Replace with your Facebook icon asset
                        onPressed: () {
                          // Handle Facebook login
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text('Don’t have an account? Sign Up', style: TextStyle(
                          color: Color(0xFF1759BD),
                          fontWeight: FontWeight.bold,
                        ),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
