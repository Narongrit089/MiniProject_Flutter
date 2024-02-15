import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mn_641463014/Login&Register/login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> registerUser(String firstname, String lastname, String email,
      String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.1.23:8080//miniProject_tourlism/register.php'),
        body: {
          'firstname': firstname,
          'lastname': lastname,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // การลงทะเบียนสำเร็จ
        final jsonData = json.decode(response.body);
        // ทำอะไรต่อได้ตามต้องการ เช่น ย้ายผู้ใช้ไปยังหน้าเข้าสู่ระบ

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('สร้างบัญชีเรียบร้อยแล้ว'),
              content: Text('สร้างบัญชีสำเร็จ เข้าสู่ระบบเพื่อดำเนินการต่อ'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
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
      } else {
        // การลงทะเบียนไม่สำเร็จ
        // แสดงข้อความแจ้งเตือนหรือดำเนินการตามต้องการ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('การลงทะเบียนไม่สำเร็จ'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      // มีข้อผิดพลาดในการเชื่อมต่อ API
      print('เกิดข้อผิดพลาดในการเชื่อมต่อ: $error');
      // ดำเนินการตามต้องการ เช่น แสดงข้อความแจ้งเตือน
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'สร้างบัญชีผู้ใช้',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'สร้างบัญชีใหม่',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      controller: _firstNameController,
                      validator: (input) {
                        if (input?.isEmpty ?? true) {
                          return 'โปรดกรอกชื่อของคุณ';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'ชื่อ',
                        hintText: 'เช่น สมชาย',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _lastNameController,
                      validator: (input) {
                        if (input?.isEmpty ?? true) {
                          return 'โปรดกรอกนามสกุลของคุณ';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'นามสกุล',
                        hintText: 'เช่น ใจดี',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _emailController,
                      validator: (input) {
                        if (input?.isEmpty ?? true) {
                          return 'โปรดกรอกอีเมล';
                        }
                        // Regular expression for email validation
                        final emailRegex =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(input!)) {
                          return 'รูปแบบอีเมลไม่ถูกต้อง';
                        }
                        return null;
                      },
                      keyboardType: TextInputType
                          .emailAddress, // กำหนดรูปแบบให้เป็น email
                      decoration: InputDecoration(
                        labelText: 'อีเมล',
                        hintText: 'user123@email.com',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _phoneController,
                      validator: (input) {
                        if (input?.isEmpty ?? true) {
                          return 'โปรดกรอกหมายเลขโทรศัพท์ของคุณ';
                        }
                        // Regular expression for phone number validation
                        final phoneRegex = RegExp(r'^[0-9]{10}$');
                        if (!phoneRegex.hasMatch(input!)) {
                          return 'โปรดกรอกหมายเลขโทรศัพท์ที่ถูกต้อง';
                        }
                        return null;
                      },
                      keyboardType:
                          TextInputType.number, // กำหนดรูปแบบให้เป็น number
                      decoration: InputDecoration(
                        labelText: 'โทรศัพท์',
                        hintText: 'เช่น 0812345678',
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _passwordController,
                      validator: (input) {
                        if (input?.isEmpty ?? true) {
                          return 'โปรดกรอกรหัสผ่าน';
                        }
                        if ((input?.length ?? 0) < 6) {
                          return 'รหัสผ่านต้องมีความยาวอย่างน้อย 6 ตัวอักษร';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'รหัสผ่าน',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _confirmPasswordController,
                      validator: (input) {
                        if (input != _passwordController.text) {
                          return 'รหัสผ่านไม่ตรงกัน';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'ยืนยันรหัสผ่าน',
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
                            _formKey.currentState?.save();
                            registerUser(
                              _firstNameController.text,
                              _lastNameController.text,
                              _emailController.text,
                              _phoneController.text,
                              _passwordController.text,
                            );
                          }
                        },
                        child: Text('สร้างบัญชี'),
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
                          // ไปยังหน้าเข้าสู่ระบบ
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          'มีบัญชีผู้ใช้อยู่แล้ว? เข้าสู่ระบบ',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
