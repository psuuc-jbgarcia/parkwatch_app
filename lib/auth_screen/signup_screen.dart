import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_validator/email_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkwatch_app/auth_screen/reg_screen.dart';
import 'package:parkwatch_app/dashboard/dashboard.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> googleSignUp() async {
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

  Future<void> facebookSignUp() async {
  try {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;

      // Check for the correct property name
      final String token = accessToken.tokenString;

      // Create a credential for Firebase authentication
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(token);

      // Sign in with the credential
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

      // Navigate to the dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ),
      );
    } else if (result.status == LoginStatus.cancelled) {
      print('Facebook sign-in was cancelled by the user.');
    } else {
      print('Facebook sign-in failed: ${result.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing in with Facebook: ${result.message}'),
        ),
      );
    }
  } catch (e) {
    print('Error with Facebook Sign-In: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error signing in with Facebook: $e'),
      ),
    );
  }
}

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
                          onPressed: googleSignUp,
                        ),
                        IconButton(
                          icon: Image.asset('assets/facebook_icon.png'), // Facebook icon from assets
                          onPressed: facebookSignUp,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        // Navigate back to the login screen
                        Navigator.pop(context);
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
