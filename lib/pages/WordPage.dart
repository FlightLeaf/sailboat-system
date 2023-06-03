import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WordPage extends StatefulWidget {
  @override
  WordPageChild  createState() =>  WordPageChild ();
}

class WordPageChild extends State<WordPage> {



  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('水质检测报告生成'),
      ),
      body: Container(
      ),

    );
  }
}


