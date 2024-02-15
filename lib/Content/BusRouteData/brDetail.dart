import 'package:flutter/material.dart';

class BusRouteDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;

  BusRouteDetailPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลเส้นทางรถบัสเพิ่มเติม'),
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
                buildDetailField('ลำดับ', data['route_no']),
                buildDetailField('รหัสสถานที่', data['codeLo']),
                buildDetailField('เวลา', data['route_time']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetailField(String labelText, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '$labelText: $value',
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}
