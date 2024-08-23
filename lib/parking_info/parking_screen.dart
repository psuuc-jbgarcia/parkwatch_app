import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parkwatch_app/parking_info/parking_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
      margin: EdgeInsets.symmetric(vertical: 10),
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
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 50, color: Colors.white),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
