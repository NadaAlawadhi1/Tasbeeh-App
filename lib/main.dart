import 'package:flutter/material.dart';
import 'package:sub7a/homePage.dart';

void main() {
  runApp(const Sub7a());
}

class Sub7a extends StatelessWidget {
  const Sub7a({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}
