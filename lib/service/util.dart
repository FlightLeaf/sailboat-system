import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_selector/file_selector.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

String exchangeData(var name){
  switch ( name ) {
    case '时间': {
      return "time";
    }
    case "经度": {
      return "longitude";
    }
    case '纬度': {
      return "latitude";
    }
    case "地址": {
      return "place";
    }
    case '温度(℃)': {
      return "temperature";
    }
    case "PH值": {
      return "PH";
    }
    case '电导率(S/m)': {
      return "electrical";
    }
    case "溶解氧(mg/L)": {
      return "O2";
    }
    case "浊度(NTU)": {
      return "dirty";
    }
    case "叶绿素(μg/L)": {
      return "green";
    }
    case "氨氮(mg/L)": {
      return "NHN";
    }
    case "水中油(mg/L)": {
      return "oil";
    }
    case "水域标准": {
      return "target";
    }
  }
  return "";
}

String exchangeName(var data){
  switch ( data ) {
    case "time": {
      return "时间";
    }
    case "longitude": {
      return "经度";
    }
    case 'latitude': {
      return "纬度";
    }
    case "place": {
      return "地点";
    }
    case 'temperature': {
      return "温度(℃)";
    }
    case "PH": {
      return "PH值";
    }
    case 'electrical': {
      return "电导率(S/m)";
    }
    case "O2": {
      return "溶解氧(mg/L)";
    }
    case 'dirty': {
      return "浊度(NTU)";
    }
    case "green": {
      return "叶绿素(μg/L)";
    }
    case "NHN": {
      return "氨氮(mg/L)";
    }
    case "oil": {
      return "水中油(mg/L)";
    }
    case "target": {
      return "水域标准";
    }
  }
  return "";
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
    if(nameList[12]['state'] == 1){
      rowData.add(dataList[i]['target'].toString());
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
