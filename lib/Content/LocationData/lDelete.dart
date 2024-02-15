import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463014/Content/LocationData/lList.dart';

class DeleteLocationPage extends StatefulWidget {
  final Map<String, dynamic> data;

  DeleteLocationPage({required this.data});

  @override
  _DeleteLocationPageState createState() => _DeleteLocationPageState();
}

class _DeleteLocationPageState extends State<DeleteLocationPage> {
  late TextEditingController locationCodeController;
  late TextEditingController locationNameController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;

  @override
  void initState() {
    super.initState();
    locationCodeController =
        TextEditingController(text: widget.data['codeLo'].toString());
    locationNameController =
        TextEditingController(text: widget.data['nameLo'].toString());
    latitudeController =
        TextEditingController(text: widget.data['latitude'].toString());
    longitudeController =
        TextEditingController(text: widget.data['longitude'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ลบข้อมูลสถานที่'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                buildReadOnlyField('รหัสสถานที่', locationCodeController),
                buildReadOnlyField('ชื่อสถานที่', locationNameController),
                buildReadOnlyField('ละติจูด', latitudeController),
                buildReadOnlyField('ลองติจูด', longitudeController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showConfirmationDialog(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/delete1.png', width: 20, height: 20),
                      SizedBox(width: 8),
                      Text('ลบข้อมูล'),
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

  Widget buildReadOnlyField(
      String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบข้อมูลสถานที่นี้'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteLocation();
              },
              child: Text('ลบ'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteLocation() async {
    String locationCode = locationCodeController.text;

    // Replace this URL with your actual API endpoint
    String apiUrl =
        'http://192.168.1.23:8080/miniProject_tourlism/CRUD/crud_location.php?case=DELETE';

    try {
      var response = await http.delete(
        Uri.parse(apiUrl),
        body: json.encode({
          'codeLo': locationCode,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showSuccessDialog(context, "ลบข้อมูลสถานที่เรียบร้อยแล้ว");
      } else {
        showSuccessDialog(
            context, "ลบข้อมูลสถานที่ไม่สำเร็จ. ${response.body}");
      }
    } catch (error) {
      showSuccessDialog(context, 'Error: $error');
    }
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

  @override
  void dispose() {
    locationCodeController.dispose();
    locationNameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }
}
