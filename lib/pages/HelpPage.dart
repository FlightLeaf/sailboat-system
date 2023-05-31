import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  @override
  _helpState createState() => _helpState();
}

class _helpState extends State<HelpPage> {

  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('帮助'),
      ),
      body: SingleChildScrollView(

      ),
    );
  }
}
