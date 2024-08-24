import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;
  bool _isLoading = true;
  bool _isEditing = false;
  final _addressController = TextEditingController();
  final _contactNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>?;
          _isEditing = false;
          _isLoading = false;
          _addressController.text = userData?['address'] ?? '';
          _contactNumberController.text = userData?['contactNumber'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _updateProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'address': _addressController.text,
          'contactNumber': _contactNumberController.text,
        }, SetOptions(merge: true));

        setState(() {
          userData = {
            ...userData!,
            'address': _addressController.text,
            'contactNumber': _contactNumberController.text,
          };
          _isEditing = false;
        });
      } catch (e) {
        print('Error updating profile: $e');
      }
    }
  }

  void _completeProfile() async {
    // Navigate to the profile completion screen and wait for it to complete
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileCompletionScreen()),
    );

    // Fetch user data again to refresh the profile screen
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          if (!_isEditing && userData != null)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: userData?['photoURL'] != null
                          ? NetworkImage(userData!['photoURL'])
                          : null,
                      child: userData?['photoURL'] == null && userData?['email'] != null
                          ? Text(
                              userData!['email']![0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  if (userData != null) ...[
                    Text(
                      userData!['displayName'] ?? 'User',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      userData!['email'] ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 30),
                    if (_isEditing) ...[
                      TextField(
                        controller: _addressController,
                        decoration: InputDecoration(labelText: 'Address'),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _contactNumberController,
                        decoration: InputDecoration(labelText: 'Contact Number'),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _updateProfile,
                        child: Text('Save'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                          });
                        },
                        child: Text('Cancel'),
                      ),
                    ] else ...[
                      ListTile(
                        leading: Icon(Icons.home),
                        title: Text('Address'),
                        subtitle: Text(userData!['address'] ?? 'Not provided'),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Contact Number'),
                        subtitle: Text(userData!['contactNumber'] ?? 'Not provided'),
                      ),
                    ]
                  ] else ...[
                    Text('No user data available.'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _completeProfile,
                      child: Text('Complete Profile'),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

class ProfileCompletionScreen extends StatefulWidget {
  @override
  _ProfileCompletionScreenState createState() => _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _addressController = TextEditingController();
  final _contactNumberController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _populateFields();
  }

  Future<void> _populateFields() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _addressController.text = '';
        _contactNumberController.text = '';
      });
    }
  }

Future<void> _saveProfile() async {
  User? user = _auth.currentUser;
  if (user != null) {
    setState(() {
      _isLoading = true;
    });
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'address': _addressController.text,
        'contactNumber': _contactNumberController.text,
        'displayName': user.displayName ?? 'User', // Use Google account name
        'email': user.email ?? '',
        'photoURL': user.photoURL ?? '', // Save the photoURL
      }, SetOptions(merge: true));

      Navigator.pop(context); // Navigate back to the previous screen after saving
    } catch (e) {
      print('Error saving profile: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Your Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please complete your profile information.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _contactNumberController,
              decoration: InputDecoration(
                labelText: 'Contact Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : () {
                setState(() {
                  _isLoading = true; // Set loading state to true
                });
                _saveProfile(); // Call the method to save the profile
              },
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
