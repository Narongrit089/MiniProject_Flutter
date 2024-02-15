import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:mn_641463014/Content/BusRouteData/brList.dart';

class EditBusRoutePage extends StatefulWidget {
  final Map<String, dynamic> data;

  EditBusRoutePage({required this.data});

  @override
  _EditBusRoutePageState createState() => _EditBusRoutePageState();
}

class _EditBusRoutePageState extends State<EditBusRoutePage> {
  late TextEditingController routeNoController;
  late TextEditingController routeTimeController;
  String? selectedCodeLo;
  late List<Map<String, dynamic>> locations;

  @override
  void initState() {
    super.initState();
    routeNoController =
        TextEditingController(text: widget.data['route_no'].toString());
    routeTimeController =
        TextEditingController(text: widget.data['route_time'].toString());
    selectedCodeLo = widget.data['codeLo'].toString();
    locations = [];
    fetchLocations();
  }

  Future<void> fetchLocations() async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.1.23:8080/miniProject_tourlism/CRUD/crud_location.php?case=GET'),
    );
    if (response.statusCode == 200) {
      final dynamic parsed = json.decode(response.body);
      if (parsed is Map<String, dynamic> && parsed.containsKey("data")) {
        setState(() {
          locations = parsed["data"].cast<Map<String, dynamic>>();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลเส้นทางรถบัส'),
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
                      Icons.directions_bus,
                      size: 50,
                      color: Colors.orange,
                    ),
                  ),
                  buildReadOnlyField('รหัสเส้นทาง', routeNoController),
                  buildLocationDropdown(),
                  buildTimeFormField(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      String updatedRouteNo = routeNoController.text;
                      String updatedRouteTime = routeTimeController.text;

                      String apiUrl =
                          'http://192.168.1.23:8080/miniProject_tourlism/CRUD/crud_busroute.php?case=PUT';

                      try {
                        var response = await http.put(
                          Uri.parse(apiUrl),
                          body: json.encode({
                            'route_no': updatedRouteNo,
                            'codeLo': selectedCodeLo,
                            'route_time': updatedRouteTime,
                          }),
                          headers: {'Content-Type': 'application/json'},
                        );

                        if (response.statusCode == 200) {
                          showSuccessDialog(
                            context,
                            "บันทึกข้อมูลเส้นทางรถบัสเรียบร้อยแล้ว.",
                          );
                        } else {
                          showSuccessDialog(
                            context,
                            "ไม่สามารถบันทึกข้อมูลเส้นทางรถบัสได้. ${response.body}",
                          );
                        }
                      } catch (error) {
                        print('Error: $error');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      primary: Colors.orange,
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

  Widget buildLocationDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCodeLo,
      decoration: InputDecoration(labelText: 'รหัสสถานที่'),
      items: locations.map((location) {
        return DropdownMenuItem<String>(
          value: location['codeLo'].toString(),
          child: Text(location['codeLo'].toString()),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          selectedCodeLo = value;
        });
      },
    );
  }

  Widget buildTimeFormField() {
    return TextFormField(
      controller: routeTimeController,
      decoration: InputDecoration(
        labelText: 'เวลาเดินทาง',
      ),
      keyboardType: TextInputType.datetime,
      onTap: () async {
        var time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (time != null) {
          setState(() {
            routeTimeController.text = DateFormat.Hm().format(DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              time.hour,
              time.minute,
            ));
          });
        }
      },
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
                    builder: (context) => BusRouteListPage(),
                  ),
                );
              },
              child: Text('กลับไปที่รายการเส้นทางรถบัส'),
            ),
          ],
        );
      },
    );
  }
}
