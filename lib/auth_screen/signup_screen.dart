import 'package:flutter/material.dart';
import 'package:flutter_email_validator/email_validator.dart';
import 'package:parkwatch_app/auth_screen/reg_screen.dart';
// import 'package:parkwatch_app/auth_screen/login_screen.dart'; // Uncomment and replace with actual path

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String? email;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            Image.asset('assets/logo.png', height: 120), // Logo from assets
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email or phone number',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!EmailValidator.validate(value)) {
                          return 'Please enter a valid email address';
                        }
                        email = value; // Store the email if it's valid
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final form = _formKey.currentState;
                        if (form != null && form.validate()) {
                          // Navigate to RegistrationScreen with the validated email
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationScreen(email: email!),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1759BD), // Set button color to #1759BD
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Or create an account with'),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Image.asset('assets/google_icon.png'), // Google icon from assets
                          onPressed: () {
                            // Handle Google sign up
                          },
                        ),
                        IconButton(
                          icon: Image.asset('assets/facebook_icon.png'), // Facebook icon from assets
                          onPressed: () {
                            // Handle Facebook sign up
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        // Navigate back to the login screen
                        Navigator.pop(context);
                        // Alternatively, use Navigator.push if LoginScreen is separate
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => LoginScreen()),
                        // );
                      },
                      child: Text(
                        'Already have an account? Log In',
                        style: TextStyle(
                          color: Color(0xFF1759BD),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
