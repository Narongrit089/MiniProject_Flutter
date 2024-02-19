import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463014/Content/BusRouteData/brList.dart';

class InsertBusRoutePage extends StatefulWidget {
  @override
  _InsertBusRoutePageState createState() => _InsertBusRoutePageState();
}

class _InsertBusRoutePageState extends State<InsertBusRoutePage> {
  late TextEditingController codeLoController;
  late TextEditingController routeTimeController;
  late List<Map<String, dynamic>> locations;
  String? selectedCodeLo;
  final _formKey =
      GlobalKey<FormState>(); // เพิ่ม GlobalKey เพื่อใช้ validate ข้อมูล

  @override
  void initState() {
    super.initState();
    codeLoController = TextEditingController();
    routeTimeController = TextEditingController();
    selectedCodeLo = null;
    locations = [];
    fetchLocations();
  }

  Future<void> fetchLocations() async {
    final response = await http.get(
      Uri.parse(
          'http://localhost:8080//miniProject_tourlism/CRUD/crud_location.php?case=GET'),
    );
    if (response.statusCode == 200) {
      final dynamic parsed = json.decode(response.body);
      if (parsed is Map<String, dynamic> && parsed.containsKey("data")) {
        setState(() {
          locations = parsed["data"].cast<Map<String, dynamic>>();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลเส้นทางรถบัส'),
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
                      Icons.directions_bus,
                      size: 50,
                      color: Colors.orange,
                    ),
                  ),
                  buildLocationDropdown(),
                  buildTimeFormField(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // ตรวจสอบความถูกต้องของข้อมูลก่อนการบันทึก
                        String codeLo = selectedCodeLo ?? "1101";
                        String routeTime = routeTimeController.text;

                        String apiUrl =
                            'http://localhost:8080//miniProject_tourlism/CRUD/crud_busroute.php?case=POST';

                        try {
                          var response = await http.post(
                            Uri.parse(apiUrl),
                            body: json.encode({
                              'codeLo': codeLo,
                              'route_time': routeTime,
                            }),
                            headers: {'Content-Type': 'application/json'},
                          );

                          if (response.statusCode == 200) {
                            showSuccessDialog(
                              context,
                              "บันทึกข้อมูลเส้นทางรถบัสเรียบร้อยแล้ว.",
                            );
                          } else {
                            showSuccessDialog(
                              context,
                              "ไม่สามารถบันทึกข้อมูลเส้นทางรถบัสได้. ${response.body}",
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
                      primary: Colors.orange, // สีพื้นหลังของปุ่ม
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

  Widget buildTextField(String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  Widget buildLocationDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCodeLo,
      decoration: InputDecoration(labelText: 'สถานที่'),
      items: locations.map((location) {
        return DropdownMenuItem<String>(
          value: location['codeLo'].toString(),
          child: Text(location['nameLo'].toString()),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          selectedCodeLo = value;
        });
      },
      validator: (value) {
        // เพิ่ม validator เพื่อตรวจสอบความถูกต้องของรหัสสถานที่
        if (value == null || value.isEmpty) {
          return 'โปรดเลือกรหัสสถานที่';
        }
        return null;
      },
    );
  }

  Widget buildTimeFormField() {
    return TextFormField(
      controller: routeTimeController,
      decoration: InputDecoration(
        labelText: 'เวลาเดินทาง',
      ),
      keyboardType: TextInputType.datetime,
      onTap: () async {
        var time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time != null) {
          setState(() {
            routeTimeController.text = '${time.hour}:${time.minute}';
          });
        }
      },
      validator: (value) {
        // เพิ่ม validator เพื่อตรวจสอบความถูกต้องของเวลาเดินทาง
        if (value == null || value.isEmpty) {
          return 'โปรดระบุเวลาเดินทาง';
        }
        return null;
      },
    );
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
    codeLoController.dispose();
    routeTimeController.dispose();
    super.dispose();
  }
}
