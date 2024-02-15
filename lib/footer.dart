import 'package:flutter/material.dart';

import 'package:mn_641463014/Content/homePage.dart';

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
            icon: Icons.home,
            label: 'หน้าหลัก',
            isSelected:
                selectedIndex == 0, // ตรวจสอบว่าเป็นเมนูที่ถูกเลือกหรือไม่
            onTap: () {
              onTap?.call(0); // เรียกใช้ onTap และส่ง index ของเมนู
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePage()), // เมื่อคลิกที่ "หน้าหลัก" ให้ไปยัง HomePage
              );
            },
          ),
          FooterItem(
            icon: Icons.location_on,
            label: 'สถานที่',
            isSelected:
                selectedIndex == 1, // ตรวจสอบว่าเป็นเมนูที่ถูกเลือกหรือไม่
            onTap: () {
              onTap?.call(1); // เรียกใช้ onTap และส่ง index ของเมนู
            },
          ),
          FooterItem(
            icon: Icons.person,
            label: 'โปรไฟล์',
            isSelected:
                selectedIndex == 2, // ตรวจสอบว่าเป็นเมนูที่ถูกเลือกหรือไม่
            onTap: () {
              onTap?.call(2); // เรียกใช้ onTap และส่ง index ของเมนู
            },
          ),
        ],
      ),
    );
  }
}

class FooterItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FooterItem({
    required this.icon,
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
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? Colors.white
                  : const Color.fromARGB(
                      255, 0, 0, 0), // กำหนดสีของไอคอนตามเงื่อนไข
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : const Color.fromARGB(
                        255, 0, 0, 0), // กำหนดสีของตัวหนังสือตามเงื่อนไข
              ),
            ),
          ],
        ),
      ),
    );
  }
}
