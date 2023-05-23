import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnalysisPage extends StatefulWidget {
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
        title: Text('数据分析'),
      ),
      body: Center(),
    );
  }
}