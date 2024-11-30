import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parkwatch_app/const/const.dart';
import 'package:parkwatch_app/dashboard/info2.dart'; // Importing the second info file
import 'package:parkwatch_app/dashboard/parkind_model.dart';
import 'package:parkwatch_app/parking_info/parking_service.dart';
import 'package:parkwatch_app/parking_info/parking_service2.dart'; // Importing ParkingService2
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // To decode the JSON response

class ParkingInfoWidget extends StatefulWidget {
  @override
  _ParkingInfoWidgetState createState() => _ParkingInfoWidgetState();
}

class _ParkingInfoWidgetState extends State<ParkingInfoWidget> with TickerProviderStateMixin {
    late PageController _pageController; // Declare the PageController

  late TabController _tabController;
  final ParkingService _parkingService = ParkingService(); // For Parking Interface 1
  final ParkingService2 _parkingService2 = ParkingService2(); // For Parking Interface 2
  Map<String, dynamic> _parkingInfo = {};
  Map<String, dynamic> _parkingInfo2 = {};
  Timer? _timer;
    Timer? model;  // Declare a Timer

  bool _showParkingInterface2 = false; // Control visibility of Parking Interface 2
  bool _isLoading = true; // Control loading state

  @override
  void initState() {
    super.initState();
        _pageController = PageController(); // Initialize the PageController

    _tabController = TabController(length: 1, vsync: this); // Start with one tab
    _fetchParkingInfo();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _fetchParkingInfo();
    });

  }

  Future<void> _fetchParkingInfo() async {
    try {
      // Fetch parking info for Parking Interface 1
      final info = await _parkingService.getParkingInfo();
      // Fetch parking info for Parking Interface 2
      final info2 = await _parkingService2.getParkingInfo();
if (this.mounted) {
      setState(() {
        _parkingInfo = info;
        _parkingInfo2 = info2;

        final int totalVehicles2 = info2['totalVehicles'] ?? 0;
        final int parkingAvailable2 = info2['parkingAvailable'] ?? 0;
        final int slotsReserved2 = info2['slotsReserved'] ?? 0;

        // Set condition to show Parking Interface 2 if any values are greater than 0
        bool showParkingInterface2 = totalVehicles2 > 0 || parkingAvailable2 > 0 || slotsReserved2 > 0;

        // Update the TabController only if the visibility changes
        if (showParkingInterface2 != _showParkingInterface2) {
          _showParkingInterface2 = showParkingInterface2;
          _tabController = TabController(length: _showParkingInterface2 ? 2 : 1, vsync: this);
        }
      });}
    } catch (e) {
      print('Error fetching parking info: $e');
    } finally {
      if (this.mounted) {
      setState(() {
        _isLoading = false; // Stop loading when done
      });
      }
    }
  }

  Widget _buildInfoCard(String label, int value, Color color, IconData icon) {
    return Container(
      margin: EdgeInsets.all(8),
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
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 35, color: Colors.white),
          SizedBox(height: 8),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
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
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Parking Info'),
        ),
        body: Center(child: Text("The server is offline",style: 
        TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold
        ),)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Parking Info'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Parking Interface'), // Always show Parking Interface
            if (_showParkingInterface2) Tab(text: 'Parking Interface 2'), // Conditionally show Parking Interface 2
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(
            child: _parkingInfo.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                'Total Vehicles Parked',
                                _parkingInfo['totalVehicles'] ?? 0,
                                Colors.blue,
                                Icons.directions_car,
                              ),
                            ),
                            Expanded(
                              child: _buildInfoCard(
                                'Parking Slot Available',
                                _parkingInfo['parkingAvailable'] ?? 0,
                                Colors.green,
                                Icons.local_parking,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoCard(
                                'Total Slot Reserved',
                                _parkingInfo['slotsReserved'] ?? 0,
                                Colors.orange,
                                Icons.event_seat,
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 10),

 // Wrap the PageView in an Expanded widget
    Expanded(
      child: PageView(
        controller: _pageController,
        children: [
          VideoFeed(cameraId: 1),
          ParkingModelImageScreen(),
        ],
      ),
    ),

      SizedBox(width: 10), // Space between video feeds
 

                      ],
                    ),
                  )
                : CircularProgressIndicator(),
          ),
          if (_showParkingInterface2)
            Center(
              child: ParkingInfoWidget2(),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tabController.dispose();
    super.dispose();
       _pageController.dispose(); // Dispose of the controller when no longer needed

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
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onHttpError: (HttpResponseError error) {
            if (this.mounted) {
            setState(() {
              _hasError = true;
            });}
          },
          onWebResourceError: (WebResourceError error) {
            if (this.mounted) {
            setState(() {
              _hasError = true;
            });}
          },
        ),
      )
      ..loadRequest(Uri.parse('$baseUrl/video_feed_flutter/1'));
  }

  void _reloadVideo() {
    if (this.mounted) {   setState(() {
      _hasError = false;
    });}
 
    _controller.loadRequest(Uri.parse('$baseUrl/video_feed_flutter/1'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      floatingActionButton: null, // Removed the reload button
    );
  }
}
