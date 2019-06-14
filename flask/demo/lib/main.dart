import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:permission/permission.dart';

void main(){ 
  runApp(MyApp());
  }

class MyApp extends StatefulWidget {
  @override
  MyAppState createState(){
    return MyAppState();
  }
}

class MyAppState extends State<MyApp>
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Center(
          child:RaisedButton(
            onPressed:()async{
              await Permission.getSinglePermissionStatus(PermissionName.Storage);
              File file = new File('pic.jpg');
              var url = 'http://seshan.pythonanywhere.com/';
              var response = await http.get(url);
              print(response);
              print('Response status: ${response.statusCode}');
              print('Response body: ${response.body}');
              //Map<String,dynamic> k = jsonDecode(response.body);
              print(response.body.runtimeType);
              file.writeAsBytes(response.bodyBytes);
              
            },
            child:Text("Click here")
          )
        )
      ),
    );
  }
}
