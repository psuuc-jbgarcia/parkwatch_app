import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:intl/intl.dart'; // Ensure this is included

class ReportIncidentScreen extends StatefulWidget {
  @override
  _ReportIncidentScreenState createState() => _ReportIncidentScreenState();
}

class _ReportIncidentScreenState extends State<ReportIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

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
        _currentUserName = user.displayName;
        if (_currentUserName == null || _currentUserName!.isEmpty) {
          _currentUserName = 'Anonymous';
        }
        print('Current User Display Name: $_currentUserName');
      });
    } else {
      setState(() {
        _currentUserName = 'Anonymous';
      });
    }
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      final description = _descriptionController.text;
      setState(() {
        _isLoading = true;
      });

      try {
        print('Submitting report for user: $_currentUserName');

        final now = DateTime.now().toUtc().add(Duration(hours: 8)); // Adjust to Philippine time
        final formattedTimestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

        await FirebaseFirestore.instance.collection('userreports').add({
          'name': _currentUserName ?? 'Anonymous',
          'description': description,
          'timestamp': formattedTimestamp, // Store formatted timestamp as string
        });

        _descriptionController.clear();
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
          _isLoading = false;
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
      btnOkOnPress: () {},
      btnOkColor: Color(0xFF1759BD),
      btnCancelColor: Colors.red,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Incident'),
      ),
      body: Container(
        color: Color(0xFFF7F9FC),
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Please describe the incident you want to report:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Incident Description',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.description, color: Colors.black54),
                    ),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1759BD),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Submit Report', style: TextStyle(fontSize: 16, color: Colors.white)),
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
