import 'package:flutter/material.dart';

import 'package:mn_641463014/Login&Register/login.dart';
import 'package:mn_641463014/Content/homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      // home: HomePage(),
    );
  }
}
