import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parkwatch_app/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parkwatch_app/auth_screen/login_screen.dart';
import 'package:parkwatch_app/auth_screen/signup_screen.dart';


// ...


void main()async {
  runApp(ParkingApp());
    WidgetsFlutterBinding.ensureInitialized(); // Ensure that Flutter binding is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
}


class ParkingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ParkWatch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/onboarding1': (context) => OnboardingScreen1(),
        '/onboarding2': (context) => OnboardingScreen2(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      // Set the flag to false to indicate that the onboarding has been shown
      await prefs.setBool('isFirstLaunch', false);
      // Navigate to onboarding
      Navigator.pushReplacementNamed(context, '/onboarding1');
    } else {
      // Navigate directly to login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/onboarding1');
          },
          child: Image.asset('assets/logo.png'), // Replace with your logo asset
        ),
      ),
    );
  }
}

class OnboardingScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/onboarding1.png', // Replace with your full-screen onboarding image
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login'); // Skip to login
                  },
                  child: Text(
                    "Skip",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/onboarding2'); // Next screen
                  },
                  child: Text(
                    "Next",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/onboarding2.png', // Replace with your full-screen onboarding image
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 20,
            right: 16,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login'); // Navigate to login
              },
              child: Text(
                "Get Started",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
