import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/io.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  _helpState createState() => _helpState();
}

class _helpState extends State<HelpPage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('帮助'),
      ),
      body: SingleChildScrollView(
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
  }
}