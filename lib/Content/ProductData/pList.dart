import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mn_641463014/footer.dart';
import 'package:mn_641463014/Content/homePage.dart';

import 'package:mn_641463014/Content/ProductData/pDetail.dart';
import 'package:mn_641463014/Content/ProductData/pEdit.dart';
import 'package:mn_641463014/Content/ProductData/pInsert.dart';
import 'package:mn_641463014/Content/ProductData/pDelete.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  bool isHovered = false;
  late Future<List<Map<String, dynamic>>> _productData;

  Future<List<Map<String, dynamic>>> _fetchProductData() async {
    final response = await http.get(Uri.parse(
        'http://localhost:8080//miniProject_tourlism/CRUD/crud_product.php?case=GET'));

    if (response.statusCode == 200) {
      final dynamic parsed = json.decode(response.body);

      if (parsed is Map<String, dynamic>) {
        if (parsed.containsKey("data") && parsed["data"] is List<dynamic>) {
          return parsed["data"].cast<Map<String, dynamic>>();
        } else {
          throw Exception('รูปแบบข้อมูลสินค้าไม่ถูกต้อง');
        }
      } else if (parsed is List<dynamic>) {
        return parsed.cast<Map<String, dynamic>>();
      } else {
        throw Exception('รูปแบบข้อมูลสินค้าไม่ถูกต้อง');
      }
    } else {
      throw Exception('การดึงข้อมูลสินค้าล้มเหลว');
    }
  }

  @override
  void initState() {
    super.initState();
    _productData = _fetchProductData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลสินค้า'),
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
                  future: _productData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('ข้อผิดพลาด: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('ไม่มีข้อมูลสินค้า');
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
                            DataColumn(label: Text('รหัสสินค้า')),
                            DataColumn(label: Text('ชื่อสินค้า')),
                            DataColumn(label: Text('เพิ่มเติม')),
                            DataColumn(label: Text('แก้ไข')),
                            DataColumn(label: Text('ลบ')),
                          ],
                          rows: snapshot.data!.map((data) {
                            return DataRow(
                              cells: <DataCell>[
                                DataCell(
                                  Text(
                                    data['codeProduct']?.toString() ?? '',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataCell(Text(
                                    data['nameProduct']?.toString() ?? '')),
                                DataCell(
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailPage(data: data),
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
                                              EditProductPage(data: data),
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
                                              DeleteProductPage(data: data),
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
                    builder: (context) => InsertProductPage(),
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
