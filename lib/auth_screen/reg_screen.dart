import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  final String email; // Receive the email as a parameter

  RegistrationScreen({required this.email});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the password fields
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Method to show the confirmation dialog
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Account'),
          content: Text('Are you sure you want to create the account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Proceed with account creation logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Processing Data')),
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0), // Remove horizontal padding
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40),
                Center(
                  child: Image.asset(
                    'assets/logo.png',
                    height: 100,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Create account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Please fill out all the necessary information',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color(0xFF6E97BD), // Set the background color
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(color: Colors.black), // Set text color to black
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white, // Set field background to white
                                labelText: 'First Name',
                                labelStyle: TextStyle(color: Colors.black), // Set label color to black
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(color: Colors.black), // Set text color to black
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white, // Set field background to white
                                labelText: 'Last Name',
                                labelStyle: TextStyle(color: Colors.black), // Set label color to black
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue: widget.email, // Pre-fill the email field with the received email
                        style: TextStyle(color: Colors.black), // Set text color to black
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white, // Set field background to white
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.black), // Set label color to black
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        readOnly: true, // Make the email field read-only
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        style: TextStyle(color: Colors.black), // Set text color to black
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white, // Set field background to white
                          labelText: 'Address',
                          labelStyle: TextStyle(color: Colors.black), // Set label color to black
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        style: TextStyle(color: Colors.black), // Set text color to black
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white, // Set field background to white
                          labelText: 'Contact Number',
                          labelStyle: TextStyle(color: Colors.black), // Set label color to black
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your contact number';
                          }
                          if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                            return 'Please enter a valid 10-digit contact number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        style: TextStyle(color: Colors.black), // Set text color to black
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white, // Set field background to white
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.black), // Set label color to black
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _confirmPasswordController,
                        style: TextStyle(color: Colors.black), // Set text color to black
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white, // Set field background to white
                          labelText: 'Confirm Password',
                          labelStyle: TextStyle(color: Colors.black), // Set label color to black
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Show the confirmation dialog
                            _showConfirmationDialog();
                          }
                        },
                        child: Text(
                          'Create',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1759BD), // Set button color to #1759BD
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
