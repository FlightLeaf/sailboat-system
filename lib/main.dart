import 'package:flutter/material.dart';
import 'package:sailboatsystem/pages/HomePage.dart';

void main() {
  //testWindowFunctions();
  runApp(const MyApp());
}

int colorNum = 0;
bool darkLight = false;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blueAccent,
        useMaterial3: true,
        fontFamily:"黑体",
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: '基于无人帆船的水质监测数据管理系统'),
    );
  }
}
