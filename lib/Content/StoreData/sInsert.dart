import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463014/Content/StoreData/sList.dart';

class InsertStorePage extends StatefulWidget {
  @override
  _InsertStorePageState createState() => _InsertStorePageState();
}

class _InsertStorePageState extends State<InsertStorePage> {
  late TextEditingController storeNameController;
  final _formKey =
      GlobalKey<FormState>(); // เพิ่ม GlobalKey เพื่อใช้ validate ข้อมูล

  @override
  void initState() {
    super.initState();
    storeNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลร้านค้า'),
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
                      Icons.store,
                      size: 50,
                      color: Colors.purple,
                    ),
                  ),
                  buildTextField(
                    'ชื่อร้านค้า',
                    storeNameController,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // ตรวจสอบความถูกต้องของข้อมูลก่อนการบันทึก
                        String storeName = storeNameController.text;

                        String apiUrl =
                            'http://localhost:8080//miniProject_tourlism/CRUD/crud_store.php?case=POST';

                        try {
                          var response = await http.post(
                            Uri.parse(apiUrl),
                            body: json.encode({
                              'nameStore': storeName,
                            }),
                            headers: {'Content-Type': 'application/json'},
                          );

                          if (response.statusCode == 200) {
                            showSuccessDialog(
                              context,
                              "เพิ่มข้อมูลร้านค้าเรียบร้อยแล้ว",
                            );
                          } else {
                            showSuccessDialog(
                              context,
                              "ไม่สามารถเพิ่มข้อมูลร้านค้าได้. ${response.body}",
                            );
                          }
                        } catch (error) {
                          print('Error: $error');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0), // กำหนดขนาดของปุ่ม
                      primary: Colors.purple, // กำหนดสีพื้นหลังของปุ่ม
                      onPrimary: Colors.white, // กำหนดสีของตัวอักษรบนปุ่ม
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

  Widget buildTextField(String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      validator: (value) {
        // เพิ่ม validator เพื่อตรวจสอบความถูกต้องของชื่อร้านค้า
        if (value == null || value.isEmpty) {
          return 'โปรดกรอกชื่อร้านค้า';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    storeNameController.dispose();
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
                // รีเฟรชหน้ารายการร้านค้า
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoreListPage(),
                  ),
                );
              },
              child: Text('กลับไปที่รายการร้านค้า'),
            ),
          ],
        );
      },
    );
  }
}
