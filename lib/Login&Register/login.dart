import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mn_641463014/Login&Register/register.dart';
import 'package:mn_641463014/Content/homePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080//miniProject_tourlism/checklogin.php'),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // เข้าสู่ระบบสำเร็จ
        final jsonData = json.decode(response.body);
        // เพิ่มโค้ดที่ต้องการทำหลังจากเข้าสู่ระบบสำเร็จ เช่น เปลี่ยนหน้า
        // Navigator.pushReplacementNamed(context, '/home');
        print("เข้าสู่ระบบสำเร็จ");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // เข้าสู่ระบบไม่สำเร็จ
        print("เข้าสู่ระบบไม่สำเร็จ");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('เข้าสู่ระบบไม่สำเร็จ'),
              content: Text('อีเมลหรือรหัสผ่านไม่ถูกต้อง'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ปิด'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      // มีข้อผิดพลาดในการเชื่อมต่อ API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาดในการเชื่อมต่อ: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 100.0),
                Center(
                  child: Text(
                    'ยินดีต้อนรับ',
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 5.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            'เข้าสู่ระบบเพื่อดำเนินการต่อ',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          SizedBox(
                              height: 30), // ระยะห่างระหว่างรูปภาพและข้อความ
                          Image.asset(
                            'images/laptop.png',
                            width: 100,
                            height: 100,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (input) {
                    if (input?.isEmpty ?? true) {
                      return 'โปรดกรอกอีเมล';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'อีเมล',
                    hintText: 'user123@email.com',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController,
                  validator: (input) {
                    if ((input?.length ?? 0) < 6) {
                      return 'โปรดกรอกรหัสผ่านอย่างน้อย 6 ตัวอักษร';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'รหัสผ่าน',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 30.0),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();
                        loginUser(email, password);
                      }
                    },
                    child: Text('เข้าสู่ระบบ'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      primary: Color.fromARGB(
                          255, 32, 194, 37), // สีพื้นหลังเป็นเขียว
                      onPrimary: Colors.white, // สีตัวหนังสือเป็นขาว
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: InkWell(
                    onTap: () {
                      // ลืมรหัสผ่าน
                    },
                    child: Text(
                      'ลืมรหัสผ่าน?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Center(
                  child: InkWell(
                    onTap: () {
                      // สร้างบัญชี
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: Text(
                      'ยังไม่มีบัญชี? สร้างบัญชี',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
