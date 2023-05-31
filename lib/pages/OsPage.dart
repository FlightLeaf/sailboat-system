import 'package:flutter/material.dart';

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
      //body: SfPdfViewer.asset('pdf/os.pdf'),
      body: Column(
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
          Center(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('序号'),),
                DataColumn(label: Text('项目'),),
                DataColumn(label: Text('第一类'),),
                DataColumn(label: Text('第二类'),),
                DataColumn(label: Text('第三类'),),
                DataColumn(label: Text('第四类'),),
              ],
              rows: const [

              ],
            ),
          ),
        ],
      ),
    );
  }
}
