import 'package:flutter/material.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage();
  @override
  AnalysisPageChild  createState() =>  AnalysisPageChild ();
}
class AnalysisPageChild extends State<AnalysisPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('数据分析'),
      ),
      body: Container(),
    );
  }
}