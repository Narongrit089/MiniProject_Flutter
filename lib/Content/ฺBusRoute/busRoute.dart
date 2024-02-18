import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusRoute extends StatefulWidget {
  @override
  _BusRouteState createState() => _BusRouteState();
}

class _BusRouteState extends State<BusRoute> {
  late GoogleMapController mapController;
  List<Marker> markers = [];
  List<Polyline> polylines = [];

  @override
  void initState() {
    super.initState();
    fetchLocationsAndDrawRoute();
  }

  Future<void> fetchLocationsAndDrawRoute() async {
    final response = await http.get(
      Uri.parse(
          'http://localhost:8080//miniProject_tourlism/CRUD/crud_location.php?case=GET'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> locations = json.decode(response.body)['data'];
      setState(() {
        markers = locations.map((location) {
          return Marker(
            markerId: MarkerId(location['codeLo']),
            position: LatLng(
              double.parse(location['latitude']),
              double.parse(location['longitude']),
            ),
            infoWindow: InfoWindow(title: location['nameLo']),
          );
        }).toList();
      });

      // ตรวจสอบว่ามีอย่างน้อยสองจุดที่จะสร้างเส้นทาง
      if (locations.length >= 2) {
        // สร้างตำแหน่งเริ่มต้นและปลายทางสำหรับเส้นทาง
        final origin = LatLng(double.parse(locations[0]['latitude']),
            double.parse(locations[0]['longitude']));
        final destination = LatLng(double.parse(locations[1]['latitude']),
            double.parse(locations[1]['longitude']));

        // สร้าง URL สำหรับ Google Maps Directions API
        final directionsUrl =
            'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=AIzaSyCejGvT7sqhBdIScABKrWHhgBAQAjp3ueo';

        // ส่งคำขอ GET ไปยัง Google Maps Directions API
        final directionsResponse = await http.get(Uri.parse(directionsUrl));

        if (directionsResponse.statusCode == 200) {
          final directionsData = json.decode(directionsResponse.body);
          final List<LatLng> routePoints = [];

          // ดึงจุดละติจูดและลองจิจูดของเส้นทาง
          directionsData['routes'][0]['legs'][0]['steps'].forEach((step) {
            final startLatLng = LatLng(
                step['start_location']['lat'], step['start_location']['lng']);
            final endLatLng = LatLng(
                step['end_location']['lat'], step['end_location']['lng']);
            routePoints.add(startLatLng);
            routePoints.add(endLatLng);
          });

          setState(() {
            polylines.add(
              Polyline(
                polylineId: PolylineId('busRoute'),
                color: Colors.blue,
                width: 3,
                points: routePoints,
              ),
            );
          });
        } else {
          throw Exception('Failed to load directions');
        }
      }
    } else {
      throw Exception('Failed to load locations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เส้นทางเดินรถ'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: Set<Marker>.of(markers),
        polylines: Set<Polyline>.of(polylines),
        initialCameraPosition: CameraPosition(
          target: LatLng(19.9777345, 99.8512275), // ตำแหน่งเริ่มต้นของแผนที่
          zoom: 14,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}
