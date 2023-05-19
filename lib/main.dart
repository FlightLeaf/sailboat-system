import 'package:flutter/material.dart';
import 'package:sailboatsystem/pages/MyHomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        fontFamily:"黑体",
      ),
      home: const MyHomePage(title: '基于无人帆船的水质监测数据管理系统'),

    );
  }
}