import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:mn_641463014/Content/ProductData/pList.dart';

class EditProductPage extends StatefulWidget {
  final Map<String, dynamic> data;

  EditProductPage({required this.data});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController codeProductController;
  late TextEditingController nameProductController;
  late TextEditingController countUnitController;
  late TextEditingController priceController;
  String? selectedCodeStore;
  late List<Map<String, dynamic>> stores;

  @override
  void initState() {
    super.initState();
    codeProductController =
        TextEditingController(text: widget.data['codeProduct'].toString());
    nameProductController =
        TextEditingController(text: widget.data['nameProduct'].toString());
    countUnitController =
        TextEditingController(text: widget.data['count_unit'].toString());
    priceController =
        TextEditingController(text: widget.data['price'].toString());
    selectedCodeStore = widget.data['codeStore'].toString();
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
        title: Text('แก้ไขข้อมูลสินค้า'),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                  buildReadOnlyField('รหัสสินค้า', codeProductController),
                  buildStoreDropdown(),
                  buildProductNameFormField(),
                  buildCountUnitFormField(),
                  buildPriceFormField(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      String updatedCodeProduct = codeProductController.text;
                      String updatedNameProduct = nameProductController.text;
                      int updatedCountUnit =
                          int.parse(countUnitController.text);
                      int updatedPrice = int.parse(priceController.text);
                      String updatedCodeStore = selectedCodeStore ?? "S001";

                      String apiUrl =
                          'http://localhost:8080//miniProject_tourlism/CRUD/crud_product.php?case=PUT';

                      try {
                        var response = await http.put(
                          Uri.parse(apiUrl),
                          body: json.encode({
                            'codeProduct': updatedCodeProduct,
                            'nameProduct': updatedNameProduct,
                            'count_unit': updatedCountUnit,
                            'price': updatedPrice,
                            'codeStore': updatedCodeStore,
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
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      primary: Colors.red,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save),
                        SizedBox(width: 8),
                        Text('บันทึกข้อมูล'),
                      ],
                    ),
                  ),
                ],
              ),
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
      controller: nameProductController,
      decoration: InputDecoration(
        labelText: 'ชื่อสินค้า',
      ),
    );
  }

  Widget buildCountUnitFormField() {
    return TextFormField(
      controller: countUnitController,
      decoration: InputDecoration(
        labelText: 'จำนวน',
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget buildPriceFormField() {
    return TextFormField(
      controller: priceController,
      decoration: InputDecoration(
        labelText: 'ราคา',
      ),
      keyboardType: TextInputType.number,
    );
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
}
