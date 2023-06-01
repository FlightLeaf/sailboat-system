import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FishPage extends StatefulWidget {
  const FishPage({super.key});

  @override
  QualityStandards  createState() =>  QualityStandards();
}
class QualityStandards extends State<FishPage> {


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('渔业水质标准'),
      ),
      body: SfPdfViewer.asset('pdf/fish.pdf'),
    );
  }
}
