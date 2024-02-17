import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463014/Content/TramData/tList.dart';

class InsertTramPage extends StatefulWidget {
  @override
  _InsertTramPageState createState() => _InsertTramPageState();
}

class _InsertTramPageState extends State<InsertTramPage> {
  late TextEditingController carNumController;
  final _formKey =
      GlobalKey<FormState>(); // เพิ่ม GlobalKey เพื่อใช้ validate ข้อมูล

  @override
  void initState() {
    super.initState();
    carNumController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลรถราง'),
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
            child: Form(
              // Wrap ด้วย Form widget
              key: _formKey, // กำหนด GlobalKey ให้กับ Form
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
                  buildTextField(
                    'หมายเลขรถ',
                    carNumController,
                    'โปรดกรอกหมายเลขรถ',
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // ตรวจสอบความถูกต้องของข้อมูลก่อนการบันทึก
                        String carNum = carNumController.text;

                        String apiUrl =
                            'http://localhost:8080//miniProject_tourlism/CRUD/crud_tram.php?case=POST';

                        try {
                          var response = await http.post(
                            Uri.parse(apiUrl),
                            body: json.encode({
                              'car_num': carNum,
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
      ),
    );
  }

  Widget buildTextField(
      String labelText, TextEditingController controller, String hintText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
      ),
      validator: (value) {
        // ใส่ validator เพื่อตรวจสอบความถูกต้องของข้อมูล
        if (value == null || value.isEmpty) {
          return 'โปรดกรอกข้อมูล';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    carNumController.dispose();
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
                // รีเฟรชหน้า List
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
