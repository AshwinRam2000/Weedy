import 'package:flutter/material.dart';
import 'constants.dart';
import 'pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        canvasColor: Color.fromRGBO(240, 243, 245, 1),
        fontFamily: "Product Sans",
        accentColor: primaryDark,
        primaryColor: primaryColor,
      ),
      routes: {"/": (_) => Home()},
    );
  }
}
