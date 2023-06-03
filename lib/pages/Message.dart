import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

class MessagePage extends StatefulWidget {
  final String time;
  const MessagePage({required this.time});
  @override
  MessagePageChild  createState() =>  MessagePageChild (time: time);
}

class MessagePageChild extends State<MessagePage> {
  final String time;
  MessagePageChild({required this.time});
  late sqlite.Database database;
  List<Map<String, dynamic>> nameList = [];
  List<DataRow> rows_ = [];
  bool isVisibleButton1 = false;
  bool isVisibleButton2 = false;
  bool isVisibleButton3 = false;
  @override
  void initState() {
    super.initState();
    database = sqlite.sqlite3.open('sailboat.sqlite');
    nameList = database.select('SELECT * FROM dataState');
    List<Map<String, dynamic>> data = [];
    data = database.select('Select * from water_data where time = \'$time\'');
    for (var i = 0; i < nameList.length; i++) {
      String name = nameList[i]['name'];
      var name_temp = exchangeData(name);

      var temp = data[0]['$name_temp'];
      rows_.add(
        DataRow(
            cells: [
              DataCell(Text('$name')),
              DataCell(Text('$temp')),
            ]
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('详细信息'),
      ),
      body: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text('操作'),
                  SizedBox(height: 15,),
                  ElevatedButton.icon(
                    onPressed: () {

                    },
                    icon: Icon(Icons.delete),
                    label: Text('删除数据'),
                  ),
                  SizedBox(height: 15,),
                  ElevatedButton.icon(
                    onPressed: () {

                    },
                    icon: Icon(Icons.table_view),
                    label: Text('导出表格'),
                  ),
                  SizedBox(height: 15,),
                  ElevatedButton.icon(
                    onPressed: () {

                    },
                    icon: Icon(Icons.newspaper),
                    label: Text('导出报告'),
                  ),
                ],
              )
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text('项目'),
                  ),
                  DataColumn(
                    label: Text('内容'),
                  ),
                ],
                rows:rows_,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              flex: 6,
              child: Column(
                children: [

                ],
              )
          ),
        ],
      ),
    );
  }
  String exchangeData(var name){
    switch ( name ) {
      case '时间': {
        return "time";
      } break;
      case "经度": {
        return "longitude";
      } break;
      case '纬度': {
        return "latitude";
      } break;
      case "地址": {
        return "place";
      } break;
      case '温度(℃)': {
        return "temperature";
      } break;
      case "PH值": {
        return "PH";
      } break;
      case '电导率(S/m)': {
        return "electrical";
      } break;
      case "溶解氧(mg/L)": {
        return "O2";
      } break;
      case '浊度(NTU)': {
        return "dirty";
      } break;
      case "叶绿素(μg/L)": {
        return "green";
      } break;
      case "氨氮(mg/L)": {
        return "NHN";
      } break;
      case "水中油(mg/L)": {
        return "oil";
      } break;
    }
    return "";
  }
}


