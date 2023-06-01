import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_selector/file_selector.dart';
import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:flutter/material.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

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
    // 在 initState 中打开数据库
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
    dataColumns.add(const DataColumn(label: Text('操作'),),);
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
      if(nameList[0]['state'] == 1){
        cells.add(DataCell(Text(list['time'].toString()),));
        //dataListItem.add(list['time'].toString());
      }
      if(nameList[1]['state'] == 1){
        cells.add(DataCell(Text(list['longitude'].toString()),));
      }
      if(nameList[2]['state'] == 1){
        cells.add(DataCell(Text(list['latitude'].toString()),));
      }
      if(nameList[3]['state'] == 1){
        cells.add(DataCell(Text(list['place'].toString()),));
      }
      if(nameList[4]['state'] == 1){
        cells.add(DataCell(Text(list['temperature'].toString()),));
      }
      if(nameList[5]['state'] == 1){
        cells.add(DataCell(Text(list['PH'].toString()),));
      }
      if(nameList[6]['state'] == 1){
        cells.add(DataCell(Text(list['electrical'].toString()),));
      }
      if(nameList[7]['state'] == 1){
        cells.add(DataCell(Text(list['O2'].toString()),));
      }
      if(nameList[8]['state'] == 1){
        cells.add(DataCell(Text(list['dirty'].toString()),));
      }
      if(nameList[9]['state'] == 1){
        cells.add(DataCell(Text(list['green'].toString()),));
      }
      if(nameList[10]['state'] == 1){
        cells.add(DataCell(Text(list['NHN'].toString()),));
      }
      if(nameList[11]['state'] == 1){
        cells.add(DataCell(Text(list['oil'].toString()),));
      }
      cells.add(DataCell(IconButton(
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
      ),));
      dataRows.add(DataRow(cells: cells));
    }
    //print(dataListItem);
    setState(() {});
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
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      sql = 'SELECT * FROM water_data WHERE time LIKE \'%$search%\' OR place LIKE \'%$search%\'';
                      sql_new = sql + ' ORDER BY time ASC';
                      final result = database.select(sql_new);
                      setState(() {
                        dataList = result;
                        BuildTable();
                      });
                    },
                    child: Text('搜索'),
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
                ),
              ),
            )
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
        child: Icon(Icons.align_horizontal_left),
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
      case "地点": {
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

void exportExcel(List<Map<String, dynamic>> dataList) async {
  var excel = Excel.createExcel();
  // 创建工作表
  var sheet = excel['Sheet1'];

  // 写入表头
  late sqlite.Database database;
  database = sqlite.sqlite3.open('sailboat.sqlite');
  List<Map<String, dynamic>> nameList = [];
  var tableHeaders = [];
  nameList = database.select('SELECT * FROM dataState');
  for (var i = 0; i < nameList.length; i++) {
    String name = nameList[i]['name'];
    if(nameList[i]['state'] == 1){
      tableHeaders.add(name);
    }
  }

  for (var i = 0; i < tableHeaders.length; i++) {
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0)).value = tableHeaders[i];
  }
  // 写入数据
  for (var i = 0; i < dataList.length; i++) {
    var rowData = [];
    rowData.clear();
    if(nameList[0]['state'] == 1){
      rowData.add(dataList[i]['time'].toString());
    }
    if(nameList[1]['state'] == 1){
      rowData.add(dataList[i]['longitude'].toString());
    }
    if(nameList[2]['state'] == 1){
      rowData.add(dataList[i]['latitude'].toString());
    }
    if(nameList[3]['state'] == 1){
      rowData.add(dataList[i]['place'].toString());
    }
    if(nameList[4]['state'] == 1){
      rowData.add(dataList[i]['temperature'].toString());
    }
    if(nameList[5]['state'] == 1){
      rowData.add(dataList[i]['PH'].toString());
    }
    if(nameList[6]['state'] == 1){
      rowData.add(dataList[i]['electrical'].toString());
    }
    if(nameList[7]['state'] == 1){
      rowData.add(dataList[i]['O2'].toString());
    }
    if(nameList[8]['state'] == 1){
      rowData.add(dataList[i]['dirty'].toString());
    }
    if(nameList[9]['state'] == 1){
      rowData.add(dataList[i]['green'].toString());
    }
    if(nameList[10]['state'] == 1){
      rowData.add(dataList[i]['NHN'].toString());
    }
    if(nameList[11]['state'] == 1){
      rowData.add(dataList[i]['oil'].toString());
    }
    for (var j = 0; j < rowData.length; j++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i+1)).value = rowData[j];
    }
  }
  const String fileName = '水质报告.xlsx';
  final String? path = await getSavePath(suggestedName: fileName);
  if (path == null) {
    return;
  }
  final Uint8List fileData = Uint8List.fromList(excel.encode()!);
  const String mimeType = 'text/plain';
  final XFile textFile =
  XFile.fromData(fileData, mimeType: mimeType, name: fileName);
  await textFile.saveTo(path);

}
