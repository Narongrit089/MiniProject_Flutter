import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463014/Content/TramData/tList.dart';

class TramDetailPage extends StatefulWidget {
  final Map<String, dynamic> data;

  TramDetailPage({required this.data});

  @override
  _TramDetailPageState createState() => _TramDetailPageState();
}

class _TramDetailPageState extends State<TramDetailPage> {
  late TextEditingController tramCodeController;
  late TextEditingController carNumController;

  @override
  void initState() {
    super.initState();
    tramCodeController =
        TextEditingController(text: widget.data['tram_code'].toString());
    carNumController =
        TextEditingController(text: widget.data['car_num'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลรถรางเพิ่มเติม'),
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
                    Icons.train,
                    size: 50,
                    color: Color(0xFF2baf2b),
                  ),
                ),
                buildReadOnlyField('รหัสรถราง', tramCodeController),
                buildReadOnlyField('หมายเลขรถ', carNumController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TramListPage()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/list.png', width: 20, height: 20),
                      SizedBox(width: 8),
                      Text('กลับไปยังหน้ารายการรถราง'),
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
    tramCodeController.dispose();
    carNumController.dispose();
    super.dispose();
  }
}
