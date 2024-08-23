import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart'; // Import awesome_dialog
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkwatch_app/auth_screen/signup_screen.dart';
import 'package:parkwatch_app/dashboard/dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add a form key for validation
  bool _obscureText = true; // Variable to control the visibility of the password
  Future<void> googleSignIn() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);

        // Navigate to DashboardScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(),
          ),
        );
      } else {
        print('Google sign-in was cancelled by the user.');
      }
    } catch (e) {
      print('Error with Google Sign-In: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing in with Google: $e'),
        ),
      );
    }
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Show success alert and navigate after a short delay
        _showAlert(
          dialogType: DialogType.success,
          title: 'Success',
          desc: 'Logged in successfully',
        );

        // Delay navigation to allow alert to be dismissed
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        });
      } catch (e) {
        _showAlert(
          dialogType: DialogType.error,
          title: 'Error',
          desc: 'Error logging in: $e',
        );
      }
    }
  }

  void _showAlert({
    required DialogType dialogType,
    required String title,
    required String desc,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      headerAnimationLoop: false,
      title: title,
      desc: desc,
      btnOkOnPress: () {}, // Handle OK button press if needed
      btnOkColor: Colors.blue,  // Customize button color
      btnCancelColor: Colors.red, // Customize button color
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey, // Assign the form key to the Form widget
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
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Username or E-mail',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText, // Use the variable to control visibility
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
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
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1759BD), // Set button color to #1759BD
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      ),
                      child: Text(
                        'Log In',
                        style: TextStyle(color: Colors.white),
                      ),
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
                            googleSignIn();
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
                      child: Text(
                        'Don’t have an account? Sign Up',
                        style: TextStyle(
                          color: Color(0xFF1759BD),
                          fontWeight: FontWeight.bold,
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
    );
  }
}
