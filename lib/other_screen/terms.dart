import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  final Color mainColor = Color(0xFF007BFF); // Replace with your main color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          'Terms and Conditions',
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
                'Welcome to ParkWatch',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 16),
              Text(
                'By using our services, you agree to these terms. Please read them carefully. If you don\'t agree, please don\'t use our services.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 16),
              Text(
                'Service Overview:',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'ParkWatch offers real-time surveillance and parking management services, including space availability, vehicle counting, and alerts.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'You must provide accurate information and keep your account details confidential. You are responsible for all activities under your account.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 16),
              Text(
                'Usage Policy:',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'Use ParkWatch legally and avoid disrupting our services or accessing restricted areas.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'We collect and use your data as outlined in our Privacy Policy and take measures to protect it, but we can\'t guarantee complete security.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'All content on ParkWatch is our property and protected by law.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 16),
              Text(
                'Liability:',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'We are not liable for any indirect damages or losses related to using ParkWatch.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'We can suspend or terminate your access at any time, without notice, if you violate these terms.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 16),
              Text(
                'Changes to Terms:',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'We may update these terms. Changes will be posted here, and using ParkWatch means you accept the new terms.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'These terms are governed by the laws of our operating jurisdiction.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 16),
              Text(
                'Contact Us:',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'For questions, contact us at support@parkwatch.com.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 16),
              Text(
                'By using ParkWatch, you confirm that you have read, understood, and agree to these Terms of Service.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
