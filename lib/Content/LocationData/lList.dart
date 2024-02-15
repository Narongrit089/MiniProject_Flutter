import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mn_641463014/footer.dart'; // นำเข้าไฟล์ Footer.dart ที่มีอยู่แล้ว
import 'package:mn_641463014/Content/homePage.dart'; // นำเข้าไฟล์ Footer.dart ที่มีอยู่แล้ว

import 'package:mn_641463014/Content/LocationData/lDetail.dart'; // นำเข้าไฟล์ Footer.dart ที่มีอยู่แล้ว
import 'package:mn_641463014/Content/LocationData/lEdit.dart'; // นำเข้าไฟล์ Footer.dart ที่มีอยู่แล้ว
import 'package:mn_641463014/Content/LocationData/lInsert.dart'; // นำเข้าไฟล์ Footer.dart ที่มีอยู่แล้ว
import 'package:mn_641463014/Content/LocationData/lDelete.dart'; // นำเข้าไฟล์ Footer.dart ที่มีอยู่แล้ว

class LocationListPage extends StatefulWidget {
  @override
  _LocationListPageState createState() => _LocationListPageState();
}

class _LocationListPageState extends State<LocationListPage> {
  bool isHovered = false;
  late Future<List<Map<String, dynamic>>> _locationData;

  Future<List<Map<String, dynamic>>> _fetchLocationData() async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.23:8080/miniProject_tourlism/CRUD/crud_location.php?case=GET'));

    if (response.statusCode == 200) {
      final dynamic parsed = json.decode(response.body);

      if (parsed is Map<String, dynamic>) {
        if (parsed.containsKey("data") && parsed["data"] is List<dynamic>) {
          return parsed["data"].cast<Map<String, dynamic>>();
        } else {
          throw Exception('รูปแบบข้อมูลสถานที่ไม่ถูกต้อง');
        }
      } else if (parsed is List<dynamic>) {
        return parsed.cast<Map<String, dynamic>>();
      } else {
        throw Exception('รูปแบบข้อมูลสถานที่ไม่ถูกต้อง');
      }
    } else {
      throw Exception('การดึงข้อมูลสถานที่ล้มเหลว');
    }
  }

  @override
  void initState() {
    super.initState();
    _locationData = _fetchLocationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลสถานที่'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _locationData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('ข้อผิดพลาด: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('ไม่มีข้อมูลสถานที่');
                    } else {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 20.0,
                          headingTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          dataRowColor:
                              MaterialStateColor.resolveWith((states) {
                            return Colors.blue.withOpacity(0.1);
                          }),
                          columns: <DataColumn>[
                            DataColumn(label: Text('รหัสสถานที่')),
                            DataColumn(label: Text('ชื่อสถานที่')),
                            DataColumn(label: Text('เพิ่มเติม')),
                            DataColumn(label: Text('แก้ไข')),
                            DataColumn(label: Text('ลบ')),
                          ],
                          rows: snapshot.data!.map((data) {
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Text(
                                    data['codeLo']?.toString() ?? '',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataCell(
                                    Text(data['nameLo']?.toString() ?? '')),
                                DataCell(
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LocationDetailPage(data: data),
                                        ),
                                      );
                                    },
                                    child: Image.asset(
                                      'images/ss.png',
                                      width: 27,
                                      height: 27,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditLocationPage(data: data),
                                        ),
                                      );
                                    },
                                    child: Image.asset(
                                      'images/edit.png',
                                      width: 27,
                                      height: 27,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DeleteLocationPage(data: data),
                                        ),
                                      );
                                    },
                                    child: Image.asset(
                                      'images/delete1.png',
                                      width: 27,
                                      height: 27,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          CustomFooter(
            selectedIndex: 0, // กำหนดให้เลือก index 0 เป็นค่าเริ่มต้น
            onTap: (index) {
              // ไม่มีการนำ index ไปใช้ใน LocationListPage ดังนั้นจะไม่มีการปรับเปลี่ยนการทำงาน
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            child: FloatingActionButton(
              onPressed: () {
                // Add your logic to navigate to the page for adding data
                // For example:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InsertLocationPage(),
                  ),
                );
              },
              child: isHovered
                  ? Text(
                      'เพิ่ม',
                      style: TextStyle(
                        // สามารถปรับแต่งสไตล์ของ Text ในส่วนนี้ตามที่ต้องการ
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Icon(Icons.add),
              hoverColor: Colors.blue,
              foregroundColor: Colors
                  .white, // เพิ่ม foregroundColor เพื่อกำหนดสีของ icon/text
              backgroundColor: isHovered
                  ? Colors.blue[800]
                  : Colors.blue, // ปรับสีพื้นหลังเมื่อ Hover
              elevation:
                  isHovered ? 8 : 4, // ปรับความสูงของ shadows เมื่อ Hover
            ),
          ),
          SizedBox(height: 100), // เพิ่มระยะห่างระหว่างปุ่มและ DataTable
        ],
      ),
    );
  }
}
