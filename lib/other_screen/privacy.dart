import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final Color primaryColor = Colors.blue; // Replace with your main color
  final IconData policyIcon = Icons.lock; // Icon representing privacy

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(policyIcon, color: primaryColor, size: 36),
                SizedBox(width: 10),
                Text(
                  'ParkWatch Privacy Policy',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'We value your privacy and aim to protect your data. We collect information like IP address, browser type, device details, and location when you use our services. Cookies help us enhance your experience and analyze usage.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10),
            Text(
              'We use your information to provide and improve our services, communicate, ensure security, and prevent fraud. We may share data with trusted third parties, but they must protect it. We might also disclose information if required by law or during business transactions.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10),
            Text(
              'Manage your cookie preferences via your browser settings. Although we implement security measures, no method is entirely secure. We do not knowingly collect information from children under 18 and will delete any such data if discovered.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10),
            Text(
              'We may update this policy occasionally. Continued use of our services implies acceptance of changes. For questions, contact support@parkwatch.com.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
