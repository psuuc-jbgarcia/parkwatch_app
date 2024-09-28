import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ReportIncidentScreen extends StatefulWidget {
  @override
  _ReportIncidentScreenState createState() => _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends State<ReportIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  bool _isLoading = false; // State variable to track loading

  // Fetch the current user's display name
  String? _currentUserName;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

void _getCurrentUser() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    setState(() {
      _currentUserName = user.displayName; // Get the display name
      if (_currentUserName == null || _currentUserName!.isEmpty) {
        _currentUserName = 'Anonymous'; // Default to 'Anonymous' if display name is not set
      }
      print('Current User Display Name: $_currentUserName'); // Debug log
    });
  } else {
    setState(() {
      _currentUserName = 'Anonymous'; // Handle the case where the user is null
    });
  }
}

Future<void> _submitReport() async {
  if (_formKey.currentState!.validate()) {
    final description = _descriptionController.text;
    setState(() {
      _isLoading = true; // Set loading to true while submitting
    });

    try {
      print('Submitting report for user: $_currentUserName'); // Debug log

      // Store the report in Firestore
      await FirebaseFirestore.instance.collection('userreports').add({
        'name': _currentUserName ?? 'Anonymous', // Use the current user's name or default to 'Anonymous'
        'description': description,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the text field
      _descriptionController.clear();

      // Show success alert using AwesomeDialog
      _showAlert(
        dialogType: DialogType.success,
        title: 'Success',
        desc: 'Your report has been submitted successfully!',
      );
    } catch (e) {
      print('Error submitting report: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error submitting report: $e')));
    } finally {
      setState(() {
        _isLoading = false; // Set loading to false after submission
      });
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
      btnOkColor: Color(0xFF1759BD), // Customize button color
      btnCancelColor: Colors.red, // Customize button color
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Incident'),

      ),
      body: Container(
        color: Color(0xFFF7F9FC), // Light grey background for the body
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5, // Add elevation for the card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch to fill available width
                children: [
                  Text(
                    'Please describe the incident you want to report:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black), // Black text
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Incident Description',
                      labelStyle: TextStyle(color: Colors.black54), // Light black for label
                      border: OutlineInputBorder(), // Rounded border for the text field
                      prefixIcon: Icon(Icons.description, color: Colors.black54), // Icon color
                    ),
                    maxLines: 4, // Allow multiple lines
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitReport, // Disable button when loading
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1759BD), // Custom button color
                      padding: EdgeInsets.symmetric(vertical: 15), // Increase button height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded button
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white) // Show loading indicator
                        : Text('Submit Report', style: TextStyle(fontSize: 16, color: Colors.white)), // White text
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
