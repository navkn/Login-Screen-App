import 'package:flutter/material.dart';

import 'package:login_screen_app/pages/root_page.dart';
import 'package:login_screen_app/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          primarySwatch: Colors.green,
          brightness: Brightness.light,
          accentColor: Colors.amber),
      home: MyLoginScreen(),
    );
  }
}

class MyLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RootPage(new Auth());
  }
}
