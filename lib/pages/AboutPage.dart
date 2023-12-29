import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  AboutPageChild  createState() =>  AboutPageChild ();
}

class AboutPageChild extends State<AboutPage> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于'),
      ),
      body: Container(
      ),
    );
  }
}


