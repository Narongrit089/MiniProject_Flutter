import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463014/Content/ProductData/pList.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> data;

  ProductDetailPage({required this.data});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late TextEditingController productIdController;
  late TextEditingController productNameController;
  late TextEditingController codeStoreController;
  late TextEditingController unitController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    productIdController =
        TextEditingController(text: widget.data['codeProduct'].toString());
    productNameController =
        TextEditingController(text: widget.data['nameProduct'].toString());
    codeStoreController =
        TextEditingController(text: widget.data['nameStore'].toString());
    unitController =
        TextEditingController(text: widget.data['count_unit'].toString());
    priceController =
        TextEditingController(text: widget.data['price'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลสินค้าเพิ่ม'),
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
                    Icons.shopping_cart,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
                buildReadOnlyField('รหัสสินค้า', productIdController),
                buildReadOnlyField('ชื่อสินค้า', productNameController),
                buildReadOnlyField('ชื่อร้านค้า', codeStoreController),
                buildReadOnlyField('หน่วยนับ', unitController),
                buildReadOnlyField('ราคา', priceController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductListPage()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/list.png', width: 20, height: 20),
                      SizedBox(width: 8),
                      Text('กลับไปยังหน้ารายการสินค้า'),
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
    productIdController.dispose();
    productNameController.dispose();
    codeStoreController.dispose();
    unitController.dispose();
    priceController.dispose();
    super.dispose();
  }
}
