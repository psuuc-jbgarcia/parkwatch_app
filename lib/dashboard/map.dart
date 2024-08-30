import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController; // Nullable type
  LatLng _currentLocation = LatLng(15.996873025613311, 120.42085240900845); // Default location
  Set<Marker> _markers = {};
  final double _zoomLevel = 17.0; // Increased zoom level

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _addMarker();
  }

  void _addMarker() {
    if (mapController != null) { // Check if mapController is initialized
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('current_location'),
            position: _currentLocation,
            infoWindow: InfoWindow(
              title: 'Parking Location',
              snippet: 'You are here',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );
      });

      // Move the camera to the current location with the updated zoom level
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentLocation,
            zoom: _zoomLevel,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking Map'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _currentLocation,
          zoom: _zoomLevel, // Increased zoom level
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: _markers, // Display markers on the map
      ),
    );
  }
}
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   GoogleMapController? mapController; // Nullable type
//   LatLng _currentLocation = LatLng(15.996873025613311, 120.42085240900845); // Default location
//   LatLng _destination = LatLng(15.997, 120.422); // Example destination (change to your desired location)
//   Set<Marker> _markers = {};
//   Set<Polyline> _polylines = {}; // Set to hold polylines for the route
//   final double _zoomLevel = 15.0; // Increased zoom level

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//     _addMarker();
//   }

//   Future<void> _getCurrentLocation() async {
//     Location location = Location();

//     LocationData locationData = await location.getLocation();
//     _currentLocation = LatLng(locationData.latitude!, locationData.longitude!);

//     setState(() {
//       _addMarker();
//       _drawRoute();
//     });

//     // Move the camera to the current location
//     mapController?.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: _currentLocation,
//           zoom: _zoomLevel,
//         ),
//       ),
//     );
//   }

//   void _addMarker() {
//     setState(() {
//       _markers.add(
//         Marker(
//           markerId: MarkerId('current_location'),
//           position: _currentLocation,
//           infoWindow: InfoWindow(
//             title: 'Your Location',
//             snippet: 'You are here',
//           ),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//         ),
//       );

//       _markers.add(
//         Marker(
//           markerId: MarkerId('destination'),
//           position: _destination,
//           infoWindow: InfoWindow(
//             title: 'Destination',
//             snippet: 'Your marked place',
//           ),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         ),
//       );
//     });
//   }

//   Future<void> _drawRoute() async {
//     PolylinePoints polylinePoints = PolylinePoints();

//     // Create a PolylineRequest object with the required parameters
//     PolylineRequest request = PolylineRequest(
//       origin: PointLatLng(_currentLocation.latitude, _currentLocation.longitude),
//       destination: PointLatLng(_destination.latitude, _destination.longitude),
//       mode: TravelMode.driving, // Specify the travel mode (driving, walking, bicycling)
//     );

//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       googleApiKey: 'AIzaSyBhNY6jcmGGM5Cn5iy8_livDZfXfMNm17g', // Replace with your Google Maps API Key
//       request: request,
//     );

//     if (result.points.isNotEmpty) {
//       List<LatLng> polylineCoordinates = result.points
//           .map((point) => LatLng(point.latitude, point.longitude))
//           .toList();

//       setState(() {
//         _polylines.add(Polyline(
//           polylineId: PolylineId('route'),
//           points: polylineCoordinates,
//           color: Colors.blue,
//           width: 5,
//         ));
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Maps'),
//       ),
//       body: GoogleMap(
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: _currentLocation,
//           zoom: _zoomLevel, // Increased zoom level
//         ),
//         myLocationEnabled: true,
//         myLocationButtonEnabled: true,
//         markers: _markers, // Display markers on the map
//         polylines: _polylines, // Display the route on the map
//       ),
//     );
//   }
// }
