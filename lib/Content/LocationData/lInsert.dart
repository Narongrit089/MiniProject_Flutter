import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463014/Content/LocationData/lList.dart';

class InsertLocationPage extends StatefulWidget {
  @override
  _InsertLocationPageState createState() => _InsertLocationPageState();
}

class _InsertLocationPageState extends State<InsertLocationPage> {
  late TextEditingController locationNameController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;

  @override
  void initState() {
    super.initState();
    locationNameController = TextEditingController();
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลสถานที่'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5.0,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Icon(
                    Icons.location_on,
                    size: 50,
                    color: Colors.blue,
                  ),
                ),
                buildTextField(
                  'ชื่อสถานที่',
                  locationNameController,
                ),
                buildTextField(
                  'ละติจูด',
                  latitudeController,
                ),
                buildTextField(
                  'ลองติจูด',
                  longitudeController,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String locationName = locationNameController.text;
                    String latitude = latitudeController.text;
                    String longitude = longitudeController.text;

                    String apiUrl =
                        'http://192.168.1.23:8080/miniProject_tourlism/CRUD/crud_location.php?case=POST';

                    try {
                      var response = await http.post(
                        Uri.parse(apiUrl),
                        body: json.encode({
                          'nameLo': locationName,
                          'latitude': latitude,
                          'longitude': longitude,
                        }),
                        headers: {'Content-Type': 'application/json'},
                      );

                      if (response.statusCode == 200) {
                        showSuccessDialog(
                          context,
                          "บันทึกข้อมูลสถานที่เรียบร้อยแล้ว.",
                        );
                      } else {
                        showSuccessDialog(
                          context,
                          "ไม่สามารถบันทึกข้อมูลสถานที่ได้. ${response.body}",
                        );
                      }
                    } catch (error) {
                      print('Error: $error');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save),
                      SizedBox(width: 8),
                      Text('บันทึกข้อมูล'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  @override
  void dispose() {
    locationNameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationListPage(),
                  ),
                );
              },
              child: Text('กลับไปที่รายการสถานที่'),
            ),
          ],
        );
      },
    );
  }
}
