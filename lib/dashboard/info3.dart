import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parkwatch_app/const/const.dart';
import 'package:parkwatch_app/dashboard/parking_model3.dart';
import 'package:parkwatch_app/parking_info/parking_service3.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ParkingInfoWidget3 extends StatefulWidget {
  @override
  _ParkingInfoWidget3State createState() => _ParkingInfoWidget3State();
}

class _ParkingInfoWidget3State extends State<ParkingInfoWidget3> {
  late PageController _pageController; // Declare the PageController

  final ParkingService3 _parkingService = ParkingService3();
  Map<String, dynamic> _parkingInfo3 = {};
  Timer? _timer;

  @override
  void initState() {
    _pageController = PageController(); // Initialize the PageController
    super.initState();
    _fetchParkingInfo3();
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _fetchParkingInfo3();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
    _pageController.dispose(); // Dispose of the controller when no longer needed
  }

  Future<void> _fetchParkingInfo3() async {
    try {
      final info = await _parkingService.getParkingInfo();
      setState(() {
        _parkingInfo3 = info;
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
          Icon(icon, size: 35, color: Colors.white), // Smaller icon
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
              fontSize: 12, // Reduced font size
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
      body: Center(
        child: _parkingInfo3.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // Use a Row for the first two cards and another Row for the third
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            'Total Vehicles Parked',
                            _parkingInfo3['totalVehicles'] ?? 0,
                            Colors.blue,
                            Icons.directions_car,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoCard(
                            'Parking Slot Available',
                            _parkingInfo3['parkingAvailable'] ?? 0,
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
                            _parkingInfo3['slotsReserved'] ?? 0,
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
                          VideoFeed3(cameraId: 3),
                          ParkingModelImageScreen3(),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}

class VideoFeed3 extends StatefulWidget {
  final int cameraId;

  VideoFeed3({required this.cameraId});

  @override
  _VideoFeed3State createState() => _VideoFeed3State();
}

class _VideoFeed3State extends State<VideoFeed3> {
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
          onProgress: (int progress) {},
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
            if (request.url.startsWith('$baseUrl/video_feed/3')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('$baseUrl/video_feed/3'));
  }

  void _reloadVideo() {
    setState(() {
      _hasError = false;
    });
    _controller.loadRequest(Uri.parse('$baseUrl/video_feed/${widget.cameraId}'));
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
