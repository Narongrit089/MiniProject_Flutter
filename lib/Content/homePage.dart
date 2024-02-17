import 'package:flutter/material.dart';
import 'package:mn_641463014/footer.dart';

import 'package:mn_641463014/Content/TramData/tList.dart';
import 'package:mn_641463014/Content/LocationData/lList.dart';
import 'package:mn_641463014/Content/BusRouteData/brList.dart';
import 'package:mn_641463014/Content/StoreData/sList.dart';
import 'package:mn_641463014/Content/ProductData/pList.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // สำหรับเก็บค่า index ของเมนูที่เลือก

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าหลัก'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // กำหนดจำนวนคอลัมน์ใน GridView
              padding: EdgeInsets.all(20.0),
              children: [
                buildMenuItem(
                  'ข้อมูลรถราง',
                  Icons.train,
                  Color(0xFF2baf2b),
                  () {
                    // ไปที่หน้าข้อมูลรถราง
                    navigateToPage('ข้อมูลรถราง');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TramListPage()),
                    );
                  },
                ),
                buildMenuItem(
                  'ข้อมูลสถานที่ท่องเที่ยว',
                  Icons.place,
                  Color(0xFF03a9f4),
                  () {
                    // ไปที่หน้าข้อมูลสถานที่ท่องเที่ยว
                    navigateToPage('ข้อมูลสถานที่ท่องเที่ยว');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LocationListPage()),
                    );
                  },
                ),
                buildMenuItem(
                  'ข้อมูลเส้นทางเดินรถ',
                  Icons.directions_bus,
                  Colors.orange,
                  () {
                    // ไปที่หน้าข้อมูลเส้นทางเดินรถ
                    navigateToPage('ข้อมูลเส้นทางเดินรถ');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BusRouteListPage()),
                    );
                  },
                ),
                buildMenuItem(
                  'ข้อมูลร้านค้า',
                  Icons.store,
                  Colors.purple,
                  () {
                    // ไปที่หน้าข้อมูลร้านค้า
                    navigateToPage('ข้อมูลร้านค้า');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StoreListPage()),
                    );
                  },
                ),
                buildMenuItem(
                  'ข้อมูลสินค้า',
                  Icons.shopping_cart,
                  Colors.red,
                  () {
                    // ไปที่หน้าข้อมูลสินค้า
                    navigateToPage('ข้อมูลสินค้า');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductListPage()),
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
        return 'ข้อมูลรถราง';
      case 1:
        return 'ข้อมูลสถานที่ท่องเที่ยว';
      case 2:
        return 'ข้อมูลเส้นทางเดินรถ';
      case 3:
        return 'ข้อมูลร้านค้า';
      case 4:
        return 'ข้อมูลสินค้า';
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
