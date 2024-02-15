import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463014/Content/TramData/tList.dart';

class DeleteTramPage extends StatefulWidget {
  final Map<String, dynamic> data;

  DeleteTramPage({required this.data});

  @override
  _DeleteTramPageState createState() => _DeleteTramPageState();
}

class _DeleteTramPageState extends State<DeleteTramPage> {
  late TextEditingController tramCodeController;
  late TextEditingController carNumController;

  @override
  void initState() {
    super.initState();
    tramCodeController =
        TextEditingController(text: widget.data['tram_code'].toString());
    carNumController =
        TextEditingController(text: widget.data['car_num'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ลบข้อมูลรถราง'),
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
                    Icons.train,
                    size: 50,
                    color: Color(0xFF2baf2b),
                  ),
                ),
                buildReadOnlyField('รหัสรถราง', tramCodeController),
                buildReadOnlyField('หมายเลขรถ', carNumController),
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
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบข้อมูลรถรางนี้'),
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
                await deleteTram();
              },
              child: Text('ลบ'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteTram() async {
    String tramCode = tramCodeController.text;

    // Replace this URL with your actual API endpoint
    String apiUrl =
        'http://192.168.1.23:8080/miniProject_tourlism/CRUD/crud_tram.php?case=DELETE';

    try {
      var response = await http.delete(
        Uri.parse(apiUrl),
        body: json.encode({
          'tram_code': tramCode,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showSuccessDialog(context, "ลบข้อมูลรถรางเรียบร้อยแล้ว");
      } else {
        showSuccessDialog(context, "ลบข้อมูลรถรางไม่สำเร็จ. ${response.body}");
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
                    builder: (context) => TramListPage(),
                  ),
                );
              },
              child: Text('กลับไปที่รายการรถราง'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    tramCodeController.dispose();
    carNumController.dispose();
    super.dispose();
  }
}
