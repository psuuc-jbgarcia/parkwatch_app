import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parkwatch_app/components/drawer.dart';
import 'package:parkwatch_app/parking_info/parking_service.dart';
import 'package:webview_flutter/webview_flutter.dart';



class ParkWatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ParkWatch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF1759BD),
          secondary: Color(0xFF1759BD),
        ),
      ),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Updated _widgetOptions to include ParkingInfoWidget
  static List<Widget> _widgetOptions = <Widget>[
    ParkingIncidentsReports(),
    ParkingInfoWidget(), // Navigate to ParkingInfoWidget when "Parking Map" is selected
  ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    drawer: CustomDrawer(),
    appBar: AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/icon.png', // Ensure this path is correct
            height: 40,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF1759BD)),
    ),
    body: Container(
      color: Colors.white, // Set the background color of the body to white
      child: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    ),
    bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Parking Info',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Color(0xFF1759BD),
      backgroundColor: Colors.white, // Set background color of BottomNavigationBar
      unselectedItemColor: Colors.black, // Optional: Set color for unselected items
      onTap: _onItemTapped,
    ),
  );
}

}

class ParkingIncidentsReports extends StatelessWidget {
  final List<Map<String, String>> posts = [
    {
      'title': 'Blocked Parking Space',
      'content': 'Someone parked their car blocking my space. License plate ABC123.',
      'comments': '5 comments',
    },
    {
      'title': 'Hit and Run',
      'content': 'Witnessed a hit and run in the parking lot. I have footage from my dashcam.',
      'comments': '3 comments',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Parking Incidents'),
      
      ),
      body:ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.only(bottom: 16.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  posts[index]['title']!,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1759BD),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  posts[index]['content']!,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
          Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(
      posts[index]['comments']!,
      style: TextStyle(color: Colors.grey),
    ),
    TextButton(
      onPressed: () {
        // Handle commenting logic
      },
      child: Text('Comment'),
      style: TextButton.styleFrom(
        foregroundColor: Color(0xFF1759BD), // Updated to use 'foregroundColor'
      ),
    ),
  ],
),

              ],
            ),
          ),
        );
      },
    ) ,
    );
  }
}

// ParkingInfoWidget to replace the 'Parking Map' text with actual content


class ParkingInfoWidget extends StatefulWidget {
  @override
  _ParkingInfoWidgetState createState() => _ParkingInfoWidgetState();
}

class _ParkingInfoWidgetState extends State<ParkingInfoWidget> {
  final ParkingService _parkingService = ParkingService();
  Map<String, dynamic> _parkingInfo = {};
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchParkingInfo();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _fetchParkingInfo();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchParkingInfo() async {
    try {
      final info = await _parkingService.getParkingInfo();
      setState(() {
        _parkingInfo = info;
      });
    } catch (e) {
      print('Error fetching parking info: $e');
    }
  }

Widget _buildInfoCard(String label, int value, Color color, IconData icon) {
  return Container(
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 5,
          offset: Offset(0, 2),
        ),
      ],
    ),
    padding: EdgeInsets.fromLTRB(15, 15, 15, 70), // Adjusted bottom padding
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: Colors.white),
        SizedBox(height: 10),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking Info'),
      ),
      body: Center(
        child: _parkingInfo.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: [
                          _buildInfoCard(
                            'Total Vehicles Parked',
                            _parkingInfo['totalVehicles'] ?? 0,
                            Colors.blue,
                            Icons.directions_car,
                          ),
                          _buildInfoCard(
                            'Parking Slot Available',
                            _parkingInfo['parkingAvailable'] ?? 0,
                            Colors.green,
                            Icons.local_parking,
                          ),
                          _buildInfoCard(
                            'Total Slot Reserved',
                            _parkingInfo['slotsReserved'] ?? 0,
                            Colors.orange,
                            Icons.event_seat,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: VideoFeed(cameraId: 1),
                    ),
                  ],
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}


class VideoFeed extends StatefulWidget {
  final int cameraId;

  VideoFeed({required this.cameraId});

  @override
  _VideoFeedState createState() => _VideoFeedState();
}

class _VideoFeedState extends State<VideoFeed> {
  late WebViewController _controller;
  bool _hasError = false; // State variable to track error status

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {
            setState(() {
              _hasError = true;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _hasError = true;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('http://10.0.2.2:5000/video_feed_flutter/1')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('http://10.0.2.2:5000/video_feed_flutter/${widget.cameraId}'));
  }

  void _reloadVideo() {
    setState(() {
      _hasError = false;
    });
    _controller.loadRequest(Uri.parse('http://10.0.2.2:5000/video_feed_flutter/${widget.cameraId}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Feed ${widget.cameraId}'),
      ),
      body: _hasError
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading video feed',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _reloadVideo,
                    child: Text('Retry'),
                  ),
                ],
              ),
            )
          : WebViewWidget(controller: _controller),
      floatingActionButton: _hasError
          ? null
          : FloatingActionButton(
              onPressed: _reloadVideo,
              child: Icon(Icons.refresh),
              tooltip: 'Reload Video',
            ),
    );
  }
}






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
