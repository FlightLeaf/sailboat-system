
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:sailboatsystem/models/WaterData.dart';
import 'package:sailboatsystem/pages/Message.dart';
import 'package:sailboatsystem/service/analysis.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import '../service/util.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({super.key});
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<ViewPage> {
  var sql,search,sql_new;

  late sqlite.Database database;

  List<Map<String, dynamic>> dataList = [];
  var dataListItem;

  List<Map<String, dynamic>> nameList = [];

  var start_value,place_value,end_value;

  List<String> placeItems = [];
  List<String> startItems = [];
  List<String> endItems = [];

  //行列
  List<DataColumn> dataColumns = [];
  List<DataRow> dataRows = [];

  List<DataRow> dateRows = [];

  bool selected = false;
  int _sortColumnIndex = 1;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    database = sqlite.sqlite3.open('sailboat.sqlite');
    nameList = database.select('SELECT * FROM dataState');

    for (var i = 0; i < nameList.length; i++) {
      String name = nameList[i]['name'];
      if(nameList[i]['state'] == 1){
        dataColumns.add(DataColumn(
          label: Text(name),
          onSort: (columnIndex, ascending) {
            setState(() {
              _sortColumnIndex = columnIndex;
              _sortAscending = ascending;
              var tar = exchangeData(name);
              if (ascending) {
                sql_new = sql+' ORDER BY $tar DESC';
                final result = database.select(sql_new);
                setState(() {
                  dataList = result;
                  BuildTable();
                });
              } else {
                sql_new = sql+' ORDER BY $tar ASC';
                final result = database.select(sql_new);
                setState(() {
                  dataList = result;
                  BuildTable();
                });
              }
            });
          },
        ));
      }
    }
    dataColumns.add(const DataColumn(label: Center(child: Text('',textAlign: TextAlign.center,),),numeric: true),);
    dataList = database.select('SELECT * FROM water_data');
    List<Map<String, dynamic>> placeList = database.select('SELECT DISTINCT place FROM water_data');
    for (var element in placeList) {
      placeItems.add(element['place']);
    }
    List<Map<String, dynamic>> startList = database.select('SELECT time FROM water_data ORDER BY time ASC');
    for (var element in startList) {
      startItems.add(element['time']);
    }
    for (var element in startList) {
      endItems.add(element['time']);
    }
  }

  @override
  void dispose() {
    // 在组件关闭时释放数据库资源
    database.dispose();
    super.dispose();
  }
  void BuildTable() {
    dataRows.clear();

    for(final list in dataList){
      List<DataCell> cells = [];
      WaterData waterData = WaterData.fromJson(list);
      if(nameList[0]['state'] == 1){
        cells.add(DataCell(Text(waterData.time.toString(),style: TextStyle(),),));
      }
      if(nameList[1]['state'] == 1){
        cells.add(DataCell(Text(waterData.longitude.toString()),));
      }
      if(nameList[2]['state'] == 1){
        cells.add(DataCell(Text(waterData.latitude.toString()),));
      }
      if(nameList[3]['state'] == 1){
        cells.add(DataCell(Tooltip(message: '经度：'+waterData.longitude.toString()+' 纬度：'+list['latitude'].toString(),child: Text(list['place'].toString()),)));
      }
      if(nameList[4]['state'] == 1){
        cells.add(DataCell(Text(waterData.temperature.toString()),));
      }
      if(nameList[5]['state'] == 1){
        cells.add(DataCell(Text(waterData.ph.toString(),style: TextStyle(color: colorResult(waterData.ph, "PH", "海水")),),));
      }
      if(nameList[6]['state'] == 1){
        cells.add(DataCell(Text(waterData.electrical.toString()),));
      }
      if(nameList[7]['state'] == 1){
        cells.add(DataCell(Text(waterData.o2.toString()),onTap: (){ print(list['time']); },));
      }
      if(nameList[8]['state'] == 1){
        cells.add(DataCell(Tooltip(message: '',child: Text(waterData.dirty.toString()),)));
      }
      if(nameList[9]['state'] == 1){
        cells.add(DataCell(Text(waterData.green.toString()),));
      }
      if(nameList[10]['state'] == 1){
        cells.add(DataCell(Text(waterData.nhn.toString()),));
      }
      if(nameList[11]['state'] == 1){
        cells.add(DataCell(Text(waterData.oil.toString(),textAlign: TextAlign.center,),));
      }
      if(nameList[12]['state'] == 1){
        cells.add(DataCell(Text(waterData.target.toString(),textAlign: TextAlign.center,),));
      }
      cells.add(DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                tooltip: '删除信息',
                onPressed: () {
                  var time;
                  time = list['time'];
                  var sql_ = 'delete from water_data where time = \'$time\'';
                  database.execute(sql_);
                  sql_new = sql+' order BY time ASC';
                  final result = database.select(sql_new);
                  setState(() {
                    dataList = result;
                    for (final row in result) {
                      Map<String, dynamic> record = {};
                      record.clear();
                      for (var columnName in row.keys) {
                        record[columnName] = row[columnName];
                      }
                    }
                    BuildTable();
                  });
                },
                icon:Icon(Icons.delete_forever),
              ),
              IconButton(
                tooltip: '详细信息',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MessagePage(time: list['time'].toString())));
                  setState(() {
                  });
                },
                icon:Icon(Icons.more_vert),
              ),
            ],
          )
      ));
      dataRows.add(DataRow(
          cells: cells,
      ));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('数据查看'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,

        child: Column(
          children:[
            Row(
              children: [
                SizedBox(width: 30.0),
                Expanded(
                  flex: 4,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '搜索地址或时间',
                    ),
                    onChanged: (String? value){
                      setState(() {
                        search = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      sql = 'SELECT * FROM water_data WHERE time LIKE \'%$search%\' OR place LIKE \'%$search%\'';
                      sql_new = sql + ' ORDER BY time ASC';
                      final result = database.select(sql_new);
                      setState(() {
                        dataList = result;
                        BuildTable();
                      });
                    },
                    icon: Icon(Icons.search,size: 26,),
                    tooltip: '搜索',
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  flex: 2,
                  child: Text('选择地址',),
                ),
                Expanded(
                  flex: 2,
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
                  flex: 2,
                  child: Text('开始时间',),
                ),
                Expanded(
                  flex: 5,
                  child: DropdownButton<String>(
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
                  flex: 2,
                  child: Text('结束时间',),
                ),
                Expanded(
                  flex: 5,
                  child: DropdownButton<String>(
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
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      sql = 'SELECT * FROM water_data WHERE place = \'$place_value\' AND time BETWEEN \'$start_value\' AND \'$end_value\'';
                      sql_new = sql+' ORDER BY time ASC';
                      final result = database.select(sql_new);
                      setState(() {
                        dataList = result;
                        BuildTable();
                      });
                    },
                    child: Text('查询'),
                  ),
                ),
                SizedBox(width: 12.0),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: (){
                      final result = database.select(sql);
                      setState(() {
                        dataList = result;
                      });
                      exportExcel(dataList);
                    },
                    child: Text('导出EXCEL'),
                  ),
                ),
                SizedBox(width: 30.0),
              ],
            ),
            SizedBox(height: 20.0),
            Divider(),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing:45,
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  columns: dataColumns,
                  rows: dataRows,
                  //columnAlignment: WrapAlignment.center,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '全部数据',
        onPressed: (){
          sql = 'SELECT * FROM water_data';
          sql_new = sql+' ORDER BY time ASC';
          final result = database.select(sql_new);
          setState(() {
            dataList = result;
            for (final row in result) {
              Map<String, dynamic> record = {};
              record.clear();
              for (var columnName in row.keys) {
                record[columnName] = row[columnName];
              }
            }
            BuildTable();
          });
        },
        child: Icon(Icons.all_inbox),
      ),
    );
  }
}
