import 'package:flutter/material.dart';
import 'package:mn_641463014/footer.dart';

import 'package:mn_641463014/Content/Location/locationView.dart';
import 'package:mn_641463014/Content/ฺBusRoute/busRoute.dart';

class HomePage2 extends StatefulWidget {
  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  int _selectedIndex =
      1; // ตั้งค่าเริ่มต้นให้ selectedIndex เป็น 1 เมื่อเข้าหน้า homePage2

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สถานที่'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // กำหนดจำนวนคอลัมน์ใน GridView
              padding: EdgeInsets.all(20.0),
              children: [
                buildMenuItem(
                  'รายการสถานที่',
                  Icons.list_alt,
                  Color(0xFF03a9f4),
                  () {
                    navigateToPage('รายการสถานที่');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LocationView()),
                    );
                  },
                ),
                buildMenuItem(
                  'เส้นทางเดินรถ',
                  Icons.directions_bus,
                  Colors.orange,
                  () {
                    navigateToPage('เส้นทางเดินรถ');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BusRoute()),
                    );
                  },
                ),
              ],
            ),
          ),
          CustomFooter(
            selectedIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                navigateToPage(getPageName(index));
              });
            },
          ), // เพิ่ม Footer ที่นี่
        ],
      ),
    );
  }

  void navigateToPage(String pageName) {
    print('ไปที่หน้า: $pageName');
  }

  String getPageName(int index) {
    switch (index) {
      case 0:
        return 'รายการสถานที่';
      case 1:
        return 'เส้นทางเดินรถ';
      default:
        return '';
    }
  }

  Widget buildMenuItem(
      String title, IconData icon, Color color, Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 5,
        margin: EdgeInsets.all(8),
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
