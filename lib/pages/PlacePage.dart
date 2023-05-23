import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PlacePage extends StatefulWidget {
  @override
  QualityStandards  createState() =>  QualityStandards();
}
class QualityStandards extends State<PlacePage> {


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('地表水环境质量标准'),
      ),
      body: SfPdfViewer.asset('pdf/place.pdf'),
    );
  }
}
