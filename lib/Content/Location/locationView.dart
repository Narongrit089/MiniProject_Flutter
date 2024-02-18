import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mn_641463014/footer.dart';
import 'locationViewDetail.dart'; // import LocationViewDetail

class LocationView extends StatefulWidget {
  @override
  _LocationViewState createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  List<dynamic> locations = [];

  @override
  void initState() {
    super.initState();
    fetchLocations();
  }

  Future<void> fetchLocations() async {
    final response = await http.get(
      Uri.parse(
          'http://localhost:8080//miniProject_tourlism/CRUD/crud_location.php?case=GET'),
    );

    if (response.statusCode == 200) {
      setState(() {
        locations = json.decode(response.body)['data'];
      });
    } else {
      throw Exception('Failed to load locations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายการสถานที่',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final location = locations[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  location['nameLo'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color.fromARGB(
                      255,
                      0,
                      0,
                      0,
                    ),
                  ),
                ),
                subtitle: Text(
                  'Latitude: ${location['latitude']}, Longitude: ${location['longitude']}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                trailing: Icon(
                  Icons.location_on,
                  color: Color.fromARGB(
                    255,
                    237,
                    0,
                    0,
                  ),
                ),
                onTap: () {
                  // เมื่อรายการถูกแตะ
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocationViewDetail(
                        locationName: location['nameLo'],
                        latitude: double.parse(location['latitude']),
                        longitude: double.parse(location['longitude']),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomFooter(
        selectedIndex: 1, // ให้เลือกเมนู "สถานที่"
        onTap: (index) {
          // จัดการการเลือกเมนูตามต้องการ
        },
      ),
    );
  }
}
