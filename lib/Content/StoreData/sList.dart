import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mn_641463014/footer.dart'; // นำเข้าไฟล์ Footer.dart ที่มีอยู่แล้ว
import 'package:mn_641463014/Content/homePage.dart'; // นำเข้าไฟล์ Footer.dart ที่มีอยู่แล้ว

import 'package:mn_641463014/Content/StoreData/sDetail.dart'; // นำเข้าไฟล์ Footer.dart ที่มีอยู่แล้ว
import 'package:mn_641463014/Content/StoreData/sEdit.dart'; // นำเข้าไฟล์ Footer.dart ที่มีอยู่แล้ว
import 'package:mn_641463014/Content/StoreData/sInsert.dart'; // นำเข้าไฟล์ Footer.dart ที่มีอยู่แล้ว
import 'package:mn_641463014/Content/StoreData/sDelete.dart'; // นำเข้าไฟล์ Footer.dart ที่มีอยู่แล้ว

class StoreListPage extends StatefulWidget {
  @override
  _StoreListPageState createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> {
  bool isHovered = false;
  late Future<List<Map<String, dynamic>>> _storeData;

  Future<List<Map<String, dynamic>>> _fetchStoreData() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8080//miniProject_tourlism/CRUD/crud_store.php?case=GET'));

    if (response.statusCode == 200) {
      final dynamic parsed = json.decode(response.body);

      if (parsed is Map<String, dynamic>) {
        if (parsed.containsKey("data") && parsed["data"] is List<dynamic>) {
          return parsed["data"].cast<Map<String, dynamic>>();
        } else {
          throw Exception('รูปแบบข้อมูลร้านค้าไม่ถูกต้อง');
        }
      } else if (parsed is List<dynamic>) {
        return parsed.cast<Map<String, dynamic>>();
      } else {
        throw Exception('รูปแบบข้อมูลร้านค้าไม่ถูกต้อง');
      }
    } else {
      throw Exception('การดึงข้อมูลร้านค้าล้มเหลว');
    }
  }

  @override
  void initState() {
    super.initState();
    _storeData = _fetchStoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลร้านค้า'),
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
                  future: _storeData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('ข้อผิดพลาด: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('ไม่มีข้อมูลร้านค้า');
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
                            DataColumn(label: Text('รหัสร้านค้า')),
                            DataColumn(label: Text('ชื่อร้านค้า')),
                            DataColumn(label: Text('เพิ่มเติม')),
                            DataColumn(label: Text('แก้ไข')),
                            DataColumn(label: Text('ลบ')),
                          ],
                          rows: snapshot.data!.map((data) {
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Text(
                                    data['codeStore']?.toString() ?? '',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataCell(
                                    Text(data['nameStore']?.toString() ?? '')),
                                DataCell(
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              StoreDetailPage(data: data),
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
                                              StoreEditPage(data: data),
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
                                              DeleteStorePage(data: data),
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
              // ไม่มีการนำ index ไปใช้ใน StoreListPage ดังนั้นจะไม่มีการปรับเปลี่ยนการทำงาน
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
                    builder: (context) => InsertStorePage(),
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
