import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  CartPage();
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text('empty cart'),
      ),
    );
  }
}
