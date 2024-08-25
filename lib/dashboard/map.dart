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
  final double _zoomLevel = 15.0; // Increased zoom level

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
        title: Text('Google Maps'),
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
