import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class OsPage extends StatefulWidget {
  @override
  QualityStandards  createState() =>  QualityStandards();
}
class QualityStandards extends State<OsPage> {
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('海水水质标准'),
      ),
      body: SfPdfViewer.asset('pdf/os.pdf'),
    );
  }
}
