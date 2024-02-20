import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463014/Content/StoreData/sList.dart';

class StoreDetailPage extends StatefulWidget {
  final Map<String, dynamic> data;

  StoreDetailPage({required this.data});

  @override
  _StoreDetailPageState createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage> {
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
        title: Text('ข้อมูลร้านค้าเพิ่มเติม'),
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
                    Icons.store,
                    size: 50,
                    color: Colors.purple,
                  ),
                ),
                buildReadOnlyField('รหัสร้านค้า', storeCodeController),
                buildReadOnlyField('ชื่อร้านค้า', storeNameController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StoreListPage()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/list.png', width: 20, height: 20),
                      SizedBox(width: 8),
                      Text('กลับไปยังหน้ารายการร้านค้า'),
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

  @override
  void dispose() {
    storeCodeController.dispose();
    storeNameController.dispose();
    super.dispose();
  }
}
