import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_selector/file_selector.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
/*
 * TODO 数据库替换 SQLite=>MySQL
 * */
String exchangeData(var name){
  late sqlite.Database database;
  database = sqlite.sqlite3.open('sailboat.sqlite');
  List<Map<String, dynamic>> nameList = [];
  nameList = database.select('SELECT value FROM dataState where name = \'$name\'');
  return nameList[0]['value'];
}

String exchangeName(var data){
  late sqlite.Database database;
  database = sqlite.sqlite3.open('sailboat.sqlite');
  List<Map<String, dynamic>> nameList = [];
  nameList = database.select('SELECT name FROM dataState where value = \'$data\'');
  return nameList[0]['name'];
}


void exportExcel(List<Map<String, dynamic>> dataList) async {
  var excel = Excel.createExcel();
  var sheet = excel['Sheet1'];
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
  for (var i = 0; i < dataList.length; i++) {
    var rowData = [];
    rowData.clear();
    for(var list in nameList){
      if(list['state'] == 1){
        rowData.add(dataList[i][list['value'].toString()]);
      }
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
