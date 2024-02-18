import 'package:flutter/material.dart';
import 'package:mn_641463014/Login&Register/login.dart'; // Import LoginPage for navigation

import 'package:mn_641463014/Content/homePage.dart';
import 'package:mn_641463014/Content/homePage2.dart';

class CustomFooter extends StatelessWidget {
  final int selectedIndex; // เพิ่มสมาชิก selectedIndex ใน CustomFooter
  final Function(int)? onTap;

  CustomFooter({
    required this.selectedIndex, // รับค่า selectedIndex ผ่าน constructor
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 32, 194, 37), // สีพื้นหลังของ Container
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FooterItem(
            imagePath: 'images/3d-house.png', // รูปภาพสำหรับหน้าหลัก
            label: 'หน้าหลัก',
            isSelected: selectedIndex == 0,
            onTap: () {
              onTap?.call(0);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          FooterItem(
            imagePath: 'images/3d-map.png', // รูปภาพสำหรับหน้าสถานที่
            label: 'สถานที่',
            isSelected: selectedIndex == 1,
            onTap: () {
              onTap?.call(1);
              // แทนที่ด้วย Navigator.push ของหน้าที่ต้องการ
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage2()),
              );
            },
          ),
          FooterItem(
            imagePath: 'images/logout.png', // รูปภาพสำหรับออกจากระบบ
            label: 'ออกจากระบบ',
            isSelected: selectedIndex == 2,
            onTap: () {
              onTap?.call(2);
              showConfirmationDialog(context); // แสดงกล่องยืนยันการออกจากระบบ
            },
          ),
        ],
      ),
    );
  }
}

void showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('ออกจากระบบ'),
        content: Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text('ตกลง'),
          ),
        ],
      );
    },
  );
}

class FooterItem extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FooterItem({
    required this.imagePath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 24,
              height: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
