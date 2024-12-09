import 'dart:async'; // For Timer
import 'package:flutter/material.dart'; // For UI widgets
import 'package:parkwatch_app/const/const.dart';
import 'package:parkwatch_app/dashboard/info2.dart';
import 'package:parkwatch_app/dashboard/info3.dart';
import 'package:parkwatch_app/dashboard/parking_model.dart';
import 'package:webview_flutter/webview_flutter.dart'; // For web view integration
import 'package:parkwatch_app/parking_info/parking_service.dart'; // Parking service 1
import 'package:parkwatch_app/parking_info/parking_service2.dart'; // Parking service 2
import 'package:parkwatch_app/parking_info/parking_service3.dart'; // Parking service 3

class ParkingInfoWidget extends StatefulWidget {
  @override
  _ParkingInfoWidgetState createState() => _ParkingInfoWidgetState();
}

class _ParkingInfoWidgetState extends State<ParkingInfoWidget> with TickerProviderStateMixin {
      late PageController _pageController; // Declare the PageController

  late TabController _tabController; // For managing tabs
  final ParkingService _parkingService = ParkingService(); // Instance for service 1
  final ParkingService2 _parkingService2 = ParkingService2(); // Instance for service 2
  final ParkingService3 _parkingService3 = ParkingService3(); // Instance for service 3

  Map<String, dynamic> _parkingInfo = {}; // Data for interface 1
  Map<String, dynamic> _parkingInfo2 = {}; // Data for interface 2
  Map<String, dynamic> _parkingInfo3 = {}; // Data for interface 3

  Timer? _timer; // Timer for periodic updates
  bool _showParkingInterface2 = false; // Visibility flag for interface 2
  bool _showParkingInterface3 = false; // Visibility flag for interface 3
  bool _isLoading = true; // Loading state flag

  @override
  void initState() {
    super.initState();
    // Initialize TabController with a single tab
    _pageController=PageController();
    _tabController = TabController(length: 1, vsync: this);
    // Fetch parking info periodically
    _fetchParkingInfo();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) => _fetchParkingInfo());
  }

  Future<void> _fetchParkingInfo() async {
    try {
      // Fetch data for all services
      final info = await _parkingService.getParkingInfo();
      final info2 = await _parkingService2.getParkingInfo();
      final info3 = await _parkingService3.getParkingInfo();

      if (!mounted) return; // Check if widget is still active

      setState(() {
        _parkingInfo = info;
        _parkingInfo2 = info2;
        _parkingInfo3 = info3;

        // Extract data for interface 2
        final int totalVehicles2 = info2['totalVehicles'] ?? 0;
        final int parkingAvailable2 = info2['parkingAvailable'] ?? 0;
        final int slotsReserved2 = info2['slotsReserved'] ?? 0;

        // Extract data for interface 3
        final int totalVehicles3 = info3['totalVehicles'] ?? 0;
        final int parkingAvailable3 = info3['parkingAvailable'] ?? 0;
        final int slotsReserved3 = info3['slotsReserved'] ?? 0;

        // Update visibility flags
        bool previousShowParkingInterface2 = _showParkingInterface2;
        bool previousShowParkingInterface3 = _showParkingInterface3;
        _showParkingInterface2 = totalVehicles2 > 0 || parkingAvailable2 > 0 || slotsReserved2 > 0;
        _showParkingInterface3 = totalVehicles3 > 0 || parkingAvailable3 > 0 || slotsReserved3 > 0;

        // Update TabController if visibility flags change
        if (_showParkingInterface2 != previousShowParkingInterface2 || _showParkingInterface3 != previousShowParkingInterface3) {
          int tabCount = 1; // Always include the first interface
          if (_showParkingInterface2) tabCount++;
          if (_showParkingInterface3) tabCount++;
          _tabController = TabController(length: tabCount, vsync: this);
        }
      });
    } catch (e) {
      print('Error fetching parking info: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Stop loading spinner
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
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2))],
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 35, color: Colors.white),
          SizedBox(height: 8),
          Text(value.toString(), style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.white), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildParkingInterface(Map<String, dynamic> info) {
    return Center(
      child: info.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'Total Vehicles Parked',
                          info['totalVehicles'] ?? 0,
                          Colors.blue,
                          Icons.directions_car,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoCard(
                          'Parking Slot Available',
                          info['parkingAvailable'] ?? 0,
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
                          info['slotsReserved'] ?? 0,
                          Colors.orange,
                          Icons.event_seat,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Include video feed below
                   Expanded(
      child: PageView(
        controller: _pageController,
        children: [
          VideoFeed(cameraId: 1),
          ParkingModelImageScreen(),
        ],
      ),
    ),
                ],
              ),
            )
          : Text('No data available'),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Parking Info')),
        body: Center(
          child: Text("The server is offline", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Parking Info'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Parking Interface'),
            if (_showParkingInterface2) Tab(text: 'Parking Interface 2'),
            if (_showParkingInterface3) Tab(text: 'Parking Interface 3'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildParkingInterface(_parkingInfo),
          if (_showParkingInterface2) ParkingInfoWidget2(),
          if (_showParkingInterface3) ParkingInfoWidget3(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer
    _tabController.dispose(); // Dispose TabController
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
      ..loadRequest(Uri.parse('$baseUrl/${widget.cameraId}'));
  }

  void _reloadVideo() {
    if (mounted) {
      setState(() {
        _hasError = false;
      });
      _controller.loadRequest(Uri.parse('$baseUrl/${widget.cameraId}'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _hasError
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error loading video feed', style: TextStyle(color: Colors.red, fontSize: 18)),
                SizedBox(height: 20),
                ElevatedButton(onPressed: _reloadVideo, child: Text('Retry')),
              ],
            ),
          )
        : WebViewWidget(controller: _controller);
  }
}
