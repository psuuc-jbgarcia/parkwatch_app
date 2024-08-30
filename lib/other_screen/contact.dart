import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  final Color mainColor = Color(0xFF007BFF); // Replace with your main color
  final IconData contactIcon = Icons.contact_phone; // Icon for contact information

  // Function to launch a URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          'Contact Us',
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
              Row(
                children: [
                  Icon(contactIcon, color: mainColor, size: 36),
                  SizedBox(width: 10),
                  Text(
                    'ParkWatch Features',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'ParkWatch offers a range of services designed to improve parking management and enhance user experience. Our real-time surveillance and parking management system provides the following key features:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 16),
              Text(
                '• Parking Space Availability: Get real-time information on available parking spaces in your vicinity.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '• Vehicle Counting: View current vehicle counts in monitored parking areas.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '• Customizable Alerts: Receive notifications about critical occupancy levels and other important updates.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '• Analytical Reports: Access detailed reports and analytics on parking trends and usage patterns.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '• Interactive Parking Map: Use our intuitive map to find and navigate to available parking spaces.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 16),
              Text(
                'These features help reduce the time spent searching for parking, improve traffic flow, and enhance overall parking efficiency.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Icon(Icons.email, color: mainColor, size: 36),
                  SizedBox(width: 10),
                  Text(
                    'Contact Us',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: mainColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'We are here to help with any questions or concerns you may have about ParkWatch. You can reach us through the following methods:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _launchURL('mailto:garciajerico217@gmail.com'),
                child: Text(
                  'Email: support@parkwatch.com',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
              GestureDetector(
                onTap: () => _launchURL('tel:+1234567890'),
                child: Text(
                  'Phone: (123) 456-7890',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
              Text(
                'Address: Sta. Barbara, Pangasinan',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 16),
              Text(
                'Feel free to get in touch with us, and we will be happy to assist you.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
