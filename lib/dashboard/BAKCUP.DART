import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parkwatch_app/dashboard/info2.dart'; // Importing the second info file
import 'package:parkwatch_app/parking_info/parking_service.dart';
import 'package:parkwatch_app/parking_info/parking_service2.dart'; // Importing ParkingService2
import 'package:webview_flutter/webview_flutter.dart';

class ParkingInfoWidget extends StatefulWidget {
  @override
  _ParkingInfoWidgetState createState() => _ParkingInfoWidgetState();
}

class _ParkingInfoWidgetState extends State<ParkingInfoWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ParkingService _parkingService = ParkingService(); // For Parking Interface 1
  final ParkingService2 _parkingService2 = ParkingService2(); // For Parking Interface 2
  Map<String, dynamic> _parkingInfo = {};
  Map<String, dynamic> _parkingInfo2 = {}; // Store ParkingService2 info
  Timer? _timer;
  bool _showParkingInterface2 = false; // Control visibility of Parking Interface 2

  @override
  void initState() {
    super.initState();
    _initTabController(); // Initialize the TabController
    _fetchParkingInfo();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _fetchParkingInfo();
    });
  }

  void _initTabController() {
    _tabController = TabController(length: 2, vsync: this); // Keep 2 tabs regardless of condition
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchParkingInfo() async {
    try {
      // Fetch parking info for Parking Interface 1
      final info = await _parkingService.getParkingInfo();
      // Fetch parking info for Parking Interface 2
      final info2 = await _parkingService2.getParkingInfo();

      setState(() {
        _parkingInfo = info;
        _parkingInfo2 = info2;

        // Get the values of totalVehicles, parkingAvailable, and slotsReserved for Parking Interface 2
        final int totalVehicles2 = info2['totalVehicles'] ?? 0;
        final int parkingAvailable2 = info2['parkingAvailable'] ?? 0;
        final int slotsReserved2 = info2['slotsReserved'] ?? 0;

        // Set condition to show Parking Interface 2 if any values are greater than 0
        _showParkingInterface2 = totalVehicles2 > 0 || parkingAvailable2 > 0 || slotsReserved2 > 0;
      });
    } catch (e) {
      print('Error fetching parking info: $e');
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Parking Info'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Parking Interface'), // Always show Parking Interface
            Tab(text: _showParkingInterface2 ? 'Parking Interface 2' : 'Unavailable'), // Conditionally show Parking Interface 2 or Unavailable
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
                        Expanded(
                          child: VideoFeed(cameraId: 1),
                        ),
                      ],
                    ),
                  )
                : CircularProgressIndicator(),
          ),
          Center(
            child: _showParkingInterface2
                ? ParkingInfoWidget2() // Show Parking Interface 2 if available
                : Text('Parking Interface 2 is unavailable'), // Show this if Parking Interface 2 data is all zeros
          ),
        ],
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
            setState(() {
              _hasError = true;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _hasError = true;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('http://192.168.100.177:5000/video_feed_flutter/${widget.cameraId}'));
  }

  void _reloadVideo() {
    setState(() {
      _hasError = false;
    });
    _controller.loadRequest(Uri.parse('http://192.168.100.177:5000/video_feed_flutter/${widget.cameraId}'));
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
