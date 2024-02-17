import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463014/Content/StoreData/sList.dart'; // เปลี่ยน import ไปยัง StoreListPage

class StoreEditPage extends StatefulWidget {
  final Map<String, dynamic> data;

  StoreEditPage({required this.data});

  @override
  _StoreEditPageState createState() => _StoreEditPageState();
}

class _StoreEditPageState extends State<StoreEditPage> {
  late TextEditingController storeCodeController;
  late TextEditingController storeNameController;

  @override
  void initState() {
    super.initState();
    storeCodeController =
        TextEditingController(text: widget.data['codeStore'].toString());
    storeNameController =
        TextEditingController(text: widget.data['nameStore'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลร้านค้า'),
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
                      Icons.store,
                      size: 50,
                      color: Colors.purple,
                    ), // แสดงไอคอนของร้านค้า
                  ),
                  buildReadOnlyField('รหัสร้านค้า', storeCodeController),
                  TextFormField(
                    controller: storeNameController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อร้านค้า',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      String updatedStoreCode = storeCodeController.text;
                      String updatedStoreName = storeNameController.text;

                      String apiUrl =
                          'http://localhost:8080//miniProject_tourlism/CRUD/crud_store.php?case=PUT';

                      try {
                        var response = await http.put(
                          Uri.parse(apiUrl),
                          body: json.encode({
                            'codeStore': updatedStoreCode,
                            'nameStore': updatedStoreName,
                          }),
                          headers: {'Content-Type': 'application/json'},
                        );

                        if (response.statusCode == 200) {
                          showSuccessDialog(
                            context,
                            "บันทึกข้อมูลร้านค้าเรียบร้อยแล้ว.",
                          );
                        } else {
                          showSuccessDialog(
                            context,
                            "ไม่สามารถบันทึกข้อมูลร้านค้าได้. ${response.body}",
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
                      primary: Colors.purple, // สีพื้นหลังของปุ่ม
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
    storeCodeController.dispose();
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
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StoreListPage(), // เปลี่ยนเป็น StoreListPage
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
