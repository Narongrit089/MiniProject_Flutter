import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mn_641463014/Content/ProductData/pList.dart';

class InsertProductPage extends StatefulWidget {
  @override
  _InsertProductPageState createState() => _InsertProductPageState();
}

class _InsertProductPageState extends State<InsertProductPage> {
  late TextEditingController codeStoreController;
  late TextEditingController productNameController;
  late TextEditingController countUnitController;
  late TextEditingController priceController;

  late List<Map<String, dynamic>> stores;
  String? selectedCodeStore;

  @override
  void initState() {
    super.initState();
    codeStoreController = TextEditingController();
    productNameController = TextEditingController();
    countUnitController = TextEditingController();
    priceController = TextEditingController();
    selectedCodeStore = null;
    stores = [];
    fetchStores();
  }

  Future<void> fetchStores() async {
    final response = await http.get(
      Uri.parse(
          'http://localhost:8080//miniProject_tourlism/CRUD/crud_store.php?case=GET'),
    );
    if (response.statusCode == 200) {
      final dynamic parsed = json.decode(response.body);
      if (parsed is Map<String, dynamic> && parsed.containsKey("data")) {
        setState(() {
          stores = parsed["data"].cast<Map<String, dynamic>>();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลสินค้า'),
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
                    Icons.shopping_cart,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
                buildStoreDropdown(),
                buildProductNameFormField(),
                buildCountUnitFormField(),
                buildPriceFormField(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_validateInputs()) {
                      String codeStore = selectedCodeStore ?? "101";
                      String productName = productNameController.text;
                      int countUnit = int.parse(countUnitController.text);
                      int price = int.parse(priceController.text);

                      String apiUrl =
                          'http://localhost:8080//miniProject_tourlism/CRUD/crud_product.php?case=POST';

                      try {
                        var response = await http.post(
                          Uri.parse(apiUrl),
                          body: json.encode({
                            'codeStore': codeStore,
                            'nameProduct': productName,
                            'count_unit': countUnit,
                            'price': price,
                          }),
                          headers: {'Content-Type': 'application/json'},
                        );

                        if (response.statusCode == 200) {
                          showSuccessDialog(
                            context,
                            "บันทึกข้อมูลสินค้าเรียบร้อยแล้ว.",
                          );
                        } else {
                          showSuccessDialog(
                            context,
                            "ไม่สามารถบันทึกข้อมูลสินค้าได้. ${response.body}",
                          );
                        }
                      } catch (error) {
                        print('Error: $error');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 20.0), // กำหนดขนาดพื้นที่ของปุ่ม
                    primary: Colors.red, // สีพื้นหลังของปุ่ม
                    onPrimary: Colors.white, // สีของตัวอักษรบนปุ่ม
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // กำหนดรูปร่างของปุ่ม
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save), // ไอคอน
                      SizedBox(width: 8), // ระยะห่างระหว่างไอคอนกับข้อความ
                      Text('บันทึกข้อมูล'), // ข้อความ
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

  Widget buildTextField(String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }

  Widget buildStoreDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCodeStore,
      decoration: InputDecoration(labelText: 'รหัสร้านค้า'),
      items: stores.map((store) {
        return DropdownMenuItem<String>(
          value: store['codeStore'].toString(),
          child: Text(store['codeStore'].toString()),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          selectedCodeStore = value;
        });
      },
    );
  }

  Widget buildProductNameFormField() {
    return TextFormField(
      controller: productNameController,
      decoration: InputDecoration(
        labelText: 'ชื่อสินค้า',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'โปรดกรอกชื่อสินค้า';
        }
        return null;
      },
    );
  }

  Widget buildCountUnitFormField() {
    return TextFormField(
      controller: countUnitController,
      decoration: InputDecoration(
        labelText: 'จำนวน',
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'โปรดกรอกจำนวนสินค้า';
        }
        return null;
      },
    );
  }

  Widget buildPriceFormField() {
    return TextFormField(
      controller: priceController,
      decoration: InputDecoration(
        labelText: 'ราคา',
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'โปรดกรอกราคาสินค้า';
        }
        return null;
      },
    );
  }

  bool _validateInputs() {
    if (selectedCodeStore == null ||
        productNameController.text.isEmpty ||
        countUnitController.text.isEmpty ||
        priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('โปรดกรอกข้อมูลให้ครบถ้วน'),
        ),
      );
      return false;
    }
    return true;
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
                // รีเฟรชหน้า List
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
    codeStoreController.dispose();
    productNameController.dispose();
    countUnitController.dispose();
    priceController.dispose();
    super.dispose();
  }
}
