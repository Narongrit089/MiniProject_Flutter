import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // เพิ่มบรรทัดนี้

class LocationViewDetail extends StatelessWidget {
  final String locationName;
  final double latitude;
  final double longitude;

  LocationViewDetail({
    required this.locationName,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(locationName),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: MarkerId('locationMarker'),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(title: locationName),
          ),
        },
      ),
    );
  }
}
