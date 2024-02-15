import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463014/Content/BusRouteData/brList.dart';

class DeleteBusRoutePage extends StatefulWidget {
  final Map<String, dynamic> data;

  DeleteBusRoutePage({required this.data});

  @override
  _DeleteBusRoutePageState createState() => _DeleteBusRoutePageState();
}

class _DeleteBusRoutePageState extends State<DeleteBusRoutePage> {
  late TextEditingController routeNoController;
  late TextEditingController codeLoController;
  late TextEditingController routeTimeController;

  @override
  void initState() {
    super.initState();
    routeNoController =
        TextEditingController(text: widget.data['route_no'].toString());
    codeLoController =
        TextEditingController(text: widget.data['codeLo'].toString());
    routeTimeController =
        TextEditingController(text: widget.data['route_time'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ลบข้อมูลเส้นทางรถบัส'),
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
                    Icons.directions_bus,
                    size: 50,
                    color: Colors.orange,
                  ),
                ),
                buildReadOnlyField('รหัสเส้นทาง', routeNoController),
                buildReadOnlyField('รหัสสถานที่', codeLoController),
                buildReadOnlyField('เวลาเดินทาง', routeTimeController),
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
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบข้อมูลเส้นทางรถบัสนี้'),
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
                await deleteBusRoute();
              },
              child: Text('ลบ'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteBusRoute() async {
    String routeNo = routeNoController.text;

    // Replace this URL with your actual API endpoint
    String apiUrl =
        'http://192.168.1.23:8080/miniProject_tourlism/CRUD/crud_busroute.php?case=DELETE';

    try {
      var response = await http.delete(
        Uri.parse(apiUrl),
        body: json.encode({
          'route_no': routeNo,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showSuccessDialog(context, "ลบข้อมูลเส้นทางรถบัสเรียบร้อยแล้ว");
      } else {
        showSuccessDialog(
            context, "ลบข้อมูลเส้นทางรถบัสไม่สำเร็จ. ${response.body}");
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
                    builder: (context) => BusRouteListPage(),
                  ),
                );
              },
              child: Text('กลับไปที่รายการเส้นทางรถบัส'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    routeNoController.dispose();
    codeLoController.dispose();
    routeTimeController.dispose();
    super.dispose();
  }
}
