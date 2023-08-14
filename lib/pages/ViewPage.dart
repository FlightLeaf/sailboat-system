import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:sailboatsystem/pages/Message.dart';
import 'package:sailboatsystem/service/analysis.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import '../service/util.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({super.key});
  @override
  _ViewState createState() => _ViewState();
}
/*
 * TODO 数据库替换 SQLite=>MySQL
 * */
class _ViewState extends State<ViewPage> {
  var sql,search,sql_new,sql_delete;

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
    database.dispose();
    super.dispose();
  }
  void BuildTable() {
    dataRows.clear();
    for(final list in dataList){
      List<DataCell> cells = [];
      for(var name in nameList){
        if(name['state'] == 1){
          if(name['value'].toString() == 'place'&&name['special'] == 2) {
            cells.add(DataCell(Tooltip(message: '经度：'+list['latitude'].toString()+' 纬度：'+list['latitude'].toString(),child: Text(list['place'].toString()),)));
          }
          else if(name['special'] == 1){
            cells.add(DataCell(Text(list[name['value'].toString()].toString(),style: TextStyle(color: colorResult(double.parse(list[name['value']].toString()), name['value'].toString(), list['target'])),),),);
          }
          else if(name['special'] == 2){
            cells.add(DataCell(Text(list[name['value'].toString()].toString(),)),);
          }
        }
      }
      cells.add(DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                tooltip: '删除信息',
                onPressed: () {
                  YYAlertDialogWithDivider(context);
                  var time;
                  time = list['time'];
                  sql_delete = 'delete from water_data where time = \'$time\'';
                },
                icon:Icon(Icons.delete_forever),
              ),
              IconButton(
                tooltip: '详细信息',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MessagePage(time: list['time'].toString())))
                      .then((val) => val?_getRequests():null);
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

  YYDialog YYAlertDialogWithDivider(BuildContext context) {
    return YYDialog().build(context)
      ..width = 180
      ..borderRadius = 4.0
      ..text(
        padding: EdgeInsets.all(25.0),
        alignment: Alignment.center,
        text: "是否确认删除？",
        color: Colors.black,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      )
      ..divider()
      ..doubleButton(
        padding: EdgeInsets.only(top: 10.0),
        gravity: Gravity.center,
        withDivider: true,
        text1: "取消",
        color1: Colors.blue,
        fontSize1: 14.0,
        onTap1: () {
          sql_delete = null;
        },
        text2: "确定",
        color2: Colors.blue,
        fontSize2: 14.0,
        onTap2: () {
          database.execute(sql_delete);
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
      )
      ..show();
  }

  _getRequests() async{
    final result = database.select(sql_new);
    setState(() {
      dataList = result;
      BuildTable();
    });
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
                  flex: 3,
                  child: DropdownButton<String>(
                    hint: Text('选择地址',),
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
                  flex: 5,
                  child: DropdownButton<String>(
                    hint: Text('开始时间',),
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
                  flex: 5,
                  child: DropdownButton<String>(
                    hint: Text('结束时间',),
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
                  flex: 3,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      sql = 'SELECT * FROM water_data WHERE place = \'$place_value\' AND time BETWEEN \'$start_value\' AND \'$end_value\'';
                      sql_new = sql+' ORDER BY time ASC';
                      final result = database.select(sql_new);
                      setState(() {
                        dataList = result;
                        BuildTable();
                      });
                    },
                    icon: Icon(Icons.search),
                    label: Text('查询'),
                  ),
                ),
                SizedBox(width: 12.0),
                Expanded(
                  flex: 3,
                  child: ElevatedButton.icon(
                    onPressed: (){
                      final result = database.select(sql_new);
                      setState(() {
                        dataList = result;
                      });
                      exportExcel(dataList);
                    },
                    icon: Icon(Icons.table_chart),
                    label: Text('导出'),
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
