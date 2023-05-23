import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

class HelpPage extends StatefulWidget {
  @override
  HelpPageChild  createState() =>  HelpPageChild ();
}
class HelpPageChild extends State<HelpPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('帮助'),
      ),
      body: Center(),
    );
  }
}
