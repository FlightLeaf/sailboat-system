import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class OsPage extends StatefulWidget {
  @override
  QualityStandards  createState() =>  QualityStandards();
}
class QualityStandards extends State<OsPage> {

  final List<List<dynamic>> _tableData = [
    ['一类海区', 'Ⅰ类', 'Ⅱ类', 'Ⅲ类', 'Ⅳ类'],
    ['温度(℃)', '人为造成的海水温升夏季不超过\n当时当地1℃,其它季节不超过2℃', '同Ⅰ类', '人为造成的海水温升\n不超过当时当地4℃', '同Ⅲ类'],
    ['pH', '7.8~8.5同时不超出该\n海域正常变动范围的0.2pH单位', '同Ⅰ类', '6.8~8.8同时不超出该\n海城正常变动范围的0.5pH单位', '>3.0，≥2.0'],
    ['溶解氧(mg/L)>', '6.0','5.0', '4.0', '3.0'],
    ['化学需氧量(COD)≤', '2.0', '3.0', '4.0', '5.0'],
    ['高锰酸盐指数(mg/L)', '≤1.0', '1.0～2.0', '2.0～4.0', '＞4.0'],
    ['总磷(mg/L)', '≤0.01', '0.01～0.02', '0.02～0.15', '>0.15'],
    ['总氮(mg/L)', '≤0.5', '0.5～1.0', '1.0～5.0', '>5.0'],
    ['铜(mg/L)', '0.01', '0.01～0.05', '0.05～0.10', '＞0.10'],
    ['锌(mg/L)', '≤0.01', '0.01～0.05', '0.05～0.10', '＞0.10'],
    ['镉(mg/L)', '≤0.0005', '0.0005～0.001', '0.001～0.005', '＞0.005'],
    ['铅(mg/L)', '≤0.005', '0.005～0.01', '0.01～0.05', '＞0.05'],
    ['汞(mg/L)', '≤0.00005', '0.00005～0.0001', '0.0001～0.001', '＞0.001'],
    ['铜(mg/L)', '≤0.01', '0.01～0.05', '0.05～0.10', '＞0.10'],
    ['锌(mg/L)', '≤0.01', '0.01～0.05', '0.05～0.10', '＞0.10'],
    ['镉(mg/L)', '≤0.0005', '0.0005～0.001', '0.001～0.005', '＞0.005'],
    ['铅(mg/L)', '≤0.005', '0.005～0.01', '0.01～0.05', '＞0.05'],
    ['汞(mg/L)', '≤0.00005', '0.00005～0.0001', '0.0001～0.001', '＞0.001'],
  ];
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
      /*body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Text('中华人民共和国国家标准',style: TextStyle(fontSize: 25),),
            ),
            const Center(
              child: Text('海水水质标准',style: TextStyle(fontSize: 20),),
            ),
            const Center(
              child: Text('GB3097-1997',style: TextStyle(fontSize: 15),),
            ),
            const Divider(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                columns: _tableData.first.map((title) => DataColumn(label: Text(title))).toList(),
                rows: _tableData.skip(1).map((rowData) => DataRow(cells: rowData.map((cellData) => DataCell(Text(cellData.toString()))).toList())).toList(),
              ),
            ),


          ],
        ),
      ), */
    );
  }
}
