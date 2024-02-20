import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463014/Content/ProductData/pList.dart';

class DeleteProductPage extends StatefulWidget {
  final Map<String, dynamic> data;

  DeleteProductPage({required this.data});

  @override
  _DeleteProductPageState createState() => _DeleteProductPageState();
}

class _DeleteProductPageState extends State<DeleteProductPage> {
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
        title: Text('ลบข้อมูลสินค้า'),
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
                    showConfirmationDialog(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/delete1.png', width: 20, height: 20),
                      SizedBox(width: 8),
                      Text('ลบข้อมูล'),
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

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบข้อมูลสินค้านี้'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteProduct();
              },
              child: Text('ลบ'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteProduct() async {
    String productId = productIdController.text;

    // Replace this URL with your actual API endpoint
    String apiUrl =
        'http://localhost:8080//miniProject_tourlism/CRUD/crud_product.php?case=DELETE';

    try {
      var response = await http.delete(
        Uri.parse(apiUrl),
        body: json.encode({
          'codeProduct': productId,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showSuccessDialog(context, "ลบข้อมูลสินค้าเรียบร้อยแล้ว");
      } else {
        showSuccessDialog(context, "ลบข้อมูลสินค้าไม่สำเร็จ. ${response.body}");
      }
    } catch (error) {
      showSuccessDialog(context, 'Error: $error');
    }
  }

  void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductListPage(),
                  ),
                );
              },
              child: Text('กลับไปที่รายการสินค้า'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    productIdController.dispose();
    productNameController.dispose();
    super.dispose();
  }
}
