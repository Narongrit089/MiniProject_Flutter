import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mn_641463014/footer.dart';
import 'package:mn_641463014/Content/homePage.dart';

import 'package:mn_641463014/Content/BusRouteData/brDetail.dart';
import 'package:mn_641463014/Content/BusRouteData/brEdit.dart';
import 'package:mn_641463014/Content/BusRouteData/brInsert.dart';
import 'package:mn_641463014/Content/BusRouteData/brDelete.dart';

class BusRouteListPage extends StatefulWidget {
  @override
  _BusRouteListPageState createState() => _BusRouteListPageState();
}

class _BusRouteListPageState extends State<BusRouteListPage> {
  bool isHovered = false;
  late Future<List<Map<String, dynamic>>> _busRouteData;

  Future<List<Map<String, dynamic>>> _fetchBusRouteData() async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.23:8080/miniProject_tourlism/CRUD/crud_busroute.php?case=GET'));

    if (response.statusCode == 200) {
      final dynamic parsed = json.decode(response.body);

      if (parsed is Map<String, dynamic>) {
        if (parsed.containsKey("data") && parsed["data"] is List<dynamic>) {
          return parsed["data"].cast<Map<String, dynamic>>();
        } else {
          throw Exception('รูปแบบข้อมูลเส้นทางรถบัสไม่ถูกต้อง');
        }
      } else if (parsed is List<dynamic>) {
        return parsed.cast<Map<String, dynamic>>();
      } else {
        throw Exception('รูปแบบข้อมูลเส้นทางรถบัสไม่ถูกต้อง');
      }
    } else {
      throw Exception('การดึงข้อมูลเส้นทางรถบัสล้มเหลว');
    }
  }

  @override
  void initState() {
    super.initState();
    _busRouteData = _fetchBusRouteData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลเส้นทางรถบัส'),
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
                  future: _busRouteData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('ข้อผิดพลาด: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('ไม่มีข้อมูลเส้นทางรถบัส');
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
                            DataColumn(label: Text('ลำดับ')),
                            DataColumn(label: Text('รหัสสถานที่')),
                            DataColumn(label: Text('เวลา')),
                            DataColumn(label: Text('เพิ่มเติม')),
                            DataColumn(label: Text('แก้ไข')),
                            DataColumn(label: Text('ลบ')),
                          ],
                          rows: snapshot.data!.map((data) {
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Text(
                                    data['route_no']?.toString() ?? '',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataCell(
                                    Text(data['codeLo']?.toString() ?? '')),
                                DataCell(
                                    Text(data['route_time']?.toString() ?? '')),
                                DataCell(
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BusRouteDetailPage(data: data),
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
                                              EditBusRoutePage(data: data),
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
                                              DeleteBusRoutePage(data: data),
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
            selectedIndex: 0,
            onTap: (index) {},
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InsertBusRoutePage(),
                  ),
                );
              },
              child: isHovered
                  ? Text(
                      'เพิ่ม',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Icon(Icons.add),
              hoverColor: Colors.blue,
              foregroundColor: Colors.white,
              backgroundColor: isHovered ? Colors.blue[800] : Colors.blue,
              elevation: isHovered ? 8 : 4,
            ),
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
