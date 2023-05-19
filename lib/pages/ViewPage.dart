import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

class ViewPage extends StatefulWidget {
  ViewPage({Key? key});
  @override
  _ViewState createState() => _ViewState();
}


class _ViewState extends State<ViewPage> {

  final endValueKey = GlobalKey();
  final startValueKey = GlobalKey();

  late sqlite.Database database;

  List<Map<String, dynamic>> dataList = [];

  List<Map<String, dynamic>> nameList = [];

  var start_value,place_value,end_value;

  List<String> placeItems = [];
  List<String> startItems = [];
  List<String> endItems = [];
  // 创建 DataColumn 链表
  List<DataColumn> dataColumns = [];

  @override
  void initState() {
    super.initState();
    // 在 initState 中打开数据库
    database = sqlite.sqlite3.open('sailboat.sqlite');
    nameList = database.select('SELECT * FROM dataState');
    print(nameList);
    for (var i = 0; i < nameList.length; i++) {
      String name = nameList[i]['name'];
      if(nameList[i]['state'] == 1){
        dataColumns.add(DataColumn(label: Text(name)));
      }
    }
    List<Map<String, dynamic>> placeList = database.select('SELECT DISTINCT place FROM water_data');
    placeList.forEach((element) => placeItems.add(element['place']));
    List<Map<String, dynamic>> startList = database.select('SELECT time FROM water_data ORDER BY time ASC');
    startList.forEach((element) => startItems.add(element['time']));
    startList.forEach((element) => endItems.add(element['time']));

  }


  @override
  void dispose() {
    // 在组件关闭时释放数据库资源
    database.dispose();
    super.dispose();
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
      case "地点": {
        return "place";
      } break;
      case '温度': {
        return "temperature";
      } break;
      case "PH值": {
        return "PH";
      } break;
      case '电导率': {
        return "electrical";
      } break;
      case "溶解氧": {
        return "O2";
      } break;
      case '浊度': {
        return "dirty";
      } break;
      case "叶绿素": {
        return "green";
      } break;
      case "氨氮": {
        return "NHN";
      } break;
      case "水中油": {
        return "oil";
      } break;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('数据查看'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children:[
            Row(
              children: [
                SizedBox(width: 30.0),
                Expanded(
                  flex: 3,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '搜索地址或时间',
                    ),
                    onChanged: (String? value){
                      setState(() {
                        final result = database.select('SELECT * FROM water_data WHERE time LIKE \'%'+value!+'%\' OR place LIKE \'%'+value+'%\' ORDER BY time ASC');
                        setState(() {
                          dataList = result;
                        });
                      });
                    },
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Add search logic
                    },
                    child: Text('搜索'),
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: Text('选择地址',),
                ),
                Expanded(
                  flex: 1,
                  child: DropdownButton<String>(
                    focusColor: Colors.white.withOpacity(0.0),
                    value: place_value,
                    onChanged: (String? newValue) {
                      // 更新下拉框的值
                      setState(() {
                        place_value = newValue!;
                      });
                    },
                    items: placeItems.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: Text('开始时间',),
                ),
                Expanded(
                  flex: 3,
                  child: DropdownButton<String>(
                    key: startValueKey,
                    focusColor: Colors.white.withOpacity(0.0),
                    value: start_value,
                    onChanged: (String? newValue) {
                      setState(() {
                        start_value = newValue!;
                      });
                    },
                    items: startItems.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: Text('结束时间',),
                ),
                Expanded(
                  flex: 3,
                  child: DropdownButton<String>(
                    key: endValueKey,
                    focusColor: Colors.white.withOpacity(0.0),
                    value: end_value,
                    onChanged: (String? newValue) {
                      setState(() {
                        end_value = newValue!;
                      });
                    },
                    items: endItems.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(width: 12.0),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      final result = database.select('SELECT * FROM water_data WHERE place = \''+place_value+'\' AND time BETWEEN \''+start_value+'\' AND \''+end_value+'\' ORDER BY time ASC');
                      setState(() {
                        dataList = result;
                      });
                    },
                    child: Text('查询'),
                  ),
                ),
                SizedBox(width: 30.0),
              ],
            ),

            SizedBox(height: 20.0),
            DataTable(
              columns: dataColumns,
              rows: dataList.map<DataRow>((data) {
                return DataRow(cells: [
                  DataCell(Text(data["time"].toString())),
                  DataCell(Text(data["longitude"].toString())),
                  DataCell(Text(data["latitude"].toString())),
                  DataCell(Text(data["place"].toString())),
                  DataCell(Text(data["temperature"].toString())),
                  DataCell(Text(data["PH"].toString())),
                  DataCell(Text(data["electrical"].toString())),
                  DataCell(Text(data["O2"].toString())),
                  DataCell(Text(data["dirty"].toString())),
                  DataCell(Text(data["green"].toString())),
                  DataCell(Text(data["NHN"].toString())),
                  DataCell(Text(data["oil"].toString())),
                ]);
              }).toList(),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: '全部数据',
        onPressed: (){
          final result = database.select('SELECT * FROM water_data order BY time ASC');
          setState(() {
            dataList = result;
            /*List<dynamic> mutableList = List.from(dataList);
            for (int i = 0; i < mutableList.length; i++) {
              Map<String, dynamic> data = dataList[i];
              Map<String, dynamic> mutableData = Map<String, dynamic>.from(data);
              for (var i = 0; i < nameList.length; i++) {
                String name = nameList[i]['name'];
                if(nameList[i]['state'] == 0){
                  mutableData[exchangeData(name)] = '';
                }
              }
              mutableList.add(mutableData);
            }
            dataList = List.from(mutableList);
            List<DataRow> row = List.from(dataList);*/
          });
        },
        child: Icon(Icons.all_inclusive),
      ),
    );
  }
}
