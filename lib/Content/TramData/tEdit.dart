import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463014/Content/TramData/tList.dart';

class EditTramPage extends StatefulWidget {
  final Map<String, dynamic> data;

  EditTramPage({required this.data});

  @override
  _EditTramPageState createState() => _EditTramPageState();
}

class _EditTramPageState extends State<EditTramPage> {
  late TextEditingController tramCodeController;
  late TextEditingController carNumberController;

  @override
  void initState() {
    super.initState();
    tramCodeController =
        TextEditingController(text: widget.data['tram_code'].toString());
    carNumberController =
        TextEditingController(text: widget.data['car_num'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลรถราง'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                      Icons.train,
                      size: 50,
                      color: Color(0xFF2baf2b),
                    ), // แสดงไอคอนของรถราง
                  ),
                  buildReadOnlyField('รหัสรถราง', tramCodeController),
                  TextFormField(
                    controller: carNumberController,
                    decoration: InputDecoration(
                      labelText: 'หมายเลขรถ',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      String updatedTramCode = tramCodeController.text;
                      String updatedCarNumber = carNumberController.text;

                      String apiUrl =
                          'http://192.168.1.23:8080/miniProject_tourlism/CRUD/crud_tram.php?case=PUT';

                      try {
                        var response = await http.put(
                          Uri.parse(apiUrl),
                          body: json.encode({
                            'tram_code': updatedTramCode,
                            'car_num': updatedCarNumber,
                          }),
                          headers: {'Content-Type': 'application/json'},
                        );

                        if (response.statusCode == 200) {
                          showSuccessDialog(
                            context,
                            "บันทึกข้อมูลรถรางเรียบร้อยแล้ว.",
                          );
                        } else {
                          showSuccessDialog(
                            context,
                            "ไม่สามารถบันทึกข้อมูลรถรางได้. ${response.body}",
                          );
                        }
                      } catch (error) {
                        print('Error: $error');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 20.0), // กำหนดขนาดพื้นที่ของปุ่ม
                      primary: Colors.green, // สีพื้นหลังของปุ่ม
                      onPrimary: Colors.white, // สีของตัวอักษรบนปุ่ม
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // กำหนดรูปร่างของปุ่ม
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save), // ไอคอน
                        SizedBox(width: 8), // ระยะห่างระหว่างไอคอนกับข้อความ
                        Text('บันทึกข้อมูล'), // ข้อความ
                      ],
                    ),
                  ),
                ],
              ),
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

  @override
  void dispose() {
    tramCodeController.dispose();
    carNumberController.dispose();
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
}
