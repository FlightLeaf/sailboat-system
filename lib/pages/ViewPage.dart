
import 'package:flutter/material.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

class ViewPage extends StatefulWidget {
  ViewPage({Key? key});
  @override
  _ViewState createState() => _ViewState();
}


class _ViewState extends State<ViewPage> {

  late sqlite.Database database;

  List<Map<String, dynamic>> dataList = [];

  List<Map<String, dynamic>> nameList = [];

  var start_value,place_value,end_value;

  List<String> placeItems = [];
  List<String> startItems = [];
  List<String> endItems = [];
  // 创建 DataColumn 链表
  List<DataColumn> dataColumns = [];
  List<DataRow> dataRows = [];

  @override
  void initState() {
    super.initState();
    // 在 initState 中打开数据库
    database = sqlite.sqlite3.open('sailboat.sqlite');
    nameList = database.select('SELECT * FROM dataState');
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

  void BuildTable() {
    dataRows.clear();
    for(final list in dataList){
      final cells = <DataCell>[];
      if(nameList[0]['state'] == 1){
        cells.add(DataCell(Text(list['time'].toString()),));
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
      dataRows.add(DataRow(cells: cells));
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
                          BuildTable();
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
                        BuildTable();
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
              rows: dataRows,
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
            BuildTable();
          });
        },
        child: Icon(Icons.all_inclusive),
      ),
    );
  }
}