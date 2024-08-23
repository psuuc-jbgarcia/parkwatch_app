import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parkwatch_app/components/drawer.dart';
import 'package:parkwatch_app/parking_info/parking_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(ParkWatchApp());
}

class ParkWatchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    Text(
      'Profile',
      style: TextStyle(fontSize: 24, color: Color(0xFF1759BD)),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:CustomDrawer(),
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
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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
    return ListView.builder(
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

