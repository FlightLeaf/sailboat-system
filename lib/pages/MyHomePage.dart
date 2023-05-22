import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/WaterData.dart';
import 'AnalysisPage.dart';
import 'HelpPage.dart';
import 'SettingPage.dart';
import 'ViewPage.dart';
import 'WordPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late sqlite.Database database;

  List<Map<String, dynamic>> nameList = [];

  var start_value,place_value,end_value;

  List<String> placeItems = [];
  List<String> startItems = [];
  List<String> endItems = [];
  List<String> dataItems = [];

  GlobalKey chart = GlobalKey();

  List<Map<String, dynamic>> chartList = [];

  List<ChartData> chartList_new = [];

  bool _state = false;

  String name = '目标';

  void DButil(String data_value,String place,String start,String end){
    chartList_new.clear();
    database = sqlite.sqlite3.open('sailboat.sqlite');
    name = data_value;
    data_value = exchangeData(data_value);
    chartList = database.select('SELECT time,'+data_value+' FROM water_data where place = \''+place+'\' and time between \''+start+'\' and \''+end+'\'  ORDER BY time ASC');
    for (var i = 0; i < chartList.length; i++) {
      double water = chartList[i][data_value];
      String time = chartList[i]['time'];
      chartList_new.add(ChartData(time, water));
    }
    database.dispose();
  }

  @override
  void initState() {
    super.initState();
    // 在 initState 中打开数据库
    database = sqlite.sqlite3.open('sailboat.sqlite');
    nameList = database.select('SELECT name FROM dataState where state = \'1\' and special = \'1\'');
    for (var i = 0; i < nameList.length; i++) {
      String name = nameList[i]['name'];
      dataItems.add(name);
    }
    List<Map<String, dynamic>> placeList = database.select('SELECT DISTINCT place FROM water_data');
    placeList.forEach((element) => placeItems.add(element['place']));
    List<Map<String, dynamic>> startList = database.select('SELECT time FROM water_data ORDER BY time ASC');
    startList.forEach((element) => startItems.add(element['time']));
    startList.forEach((element) => endItems.add(element['time']));
  }

  void _analysisBtn(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AnalysisPage()),
    );
  }

  void _settingBtn(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingPage()),
    );
  }

  void _wordBtn(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => WordPage()));
  }

  void _helpBtn(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => HelpPage()));
  }

  void _viewBtn(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPage()));
  }

  var data_value;

  final PageController pageController = PageController(initialPage: 0);

  WaterData waterData = WaterData.fromJson({"O2": 15.6, "PH": 7.35, "NHN": 15.2, "oil": 15.6, "time": "2023-03-24", "dirty": 12.6, "green": 19.3, "place": "Qingdao", "latitude": "37", "longitude": "34", "electrical": 7.1, "temperature": 15.27272727});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.title,style: const TextStyle(fontFamily: '黑体',color: Colors.white),),
      ),
      body: Column(
        children: [
          Expanded(child: Row(
            children: [
              SizedBox(width: 30.0),
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
                child: Text('测量项目',),
              ),
              Expanded(
                flex: 2,
                child: DropdownButton<String>(
                  focusColor: Colors.white.withOpacity(0.0),
                  value: data_value,
                  onChanged: (String? newValue) {
                    // 更新下拉框的值
                    setState(() {
                      data_value = newValue!;
                    });
                  },
                  items:
                  dataItems.map<DropdownMenuItem<String>>((String value) {
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
                flex: 2,
                child: DropdownButton<String>(
                  focusColor: Colors.white.withOpacity(0.0),
                  value: start_value,
                  onChanged: (String? newValue) {
                    // 更新下拉框的值
                    setState(() {
                      start_value = newValue!;
                    });
                  },
                  items:
                  startItems.map<DropdownMenuItem<String>>((String value) {
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
                flex: 2,
                child: DropdownButton<String>(
                  focusColor: Colors.white.withOpacity(0.0),
                  value: end_value,
                  onChanged: (String? newValue){
                    setState(() {
                      end_value = newValue!;
                    });
                  },
                  items:
                  endItems.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () {
                    DButil(data_value, place_value, start_value, end_value);
                    setState(() {
                      //line = lineChart().sampleData(data,chartList);
                      _state = true;
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text('查 询',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                ),
              ),
              SizedBox(width: 30.0),
            ],
          ),),
          Divider(),
          Expanded(
            flex: 10,
            child: Row(
              children: [
                //Expanded(flex:1,child: Center(),),
                Expanded(
                  key: chart,
                  flex: 10,
                  child: _state?SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(text: name+'水质数据图表'),
                      legend: Legend(isVisible: true),
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                        shared:true,
                      ),
                      series: <LineSeries<ChartData, String>>[
                        LineSeries<ChartData, String>(
                          name: name,
                          dataSource:  chartList_new,
                          xValueMapper: (ChartData sales, _) => sales.time,
                          yValueMapper: (ChartData sales, _) => sales.data,
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          color: Colors.blue,
                          width:3,
                          markerSettings: MarkerSettings(borderColor: Colors.blueAccent,isVisible: true),
                          // 显示工具提示
                          enableTooltip: true,
                        )
                      ]
                  ):Container(),
                ),
                //Expanded(flex:1,child: Center(),),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
            ),
          ),
        ],//test
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('Unmanned sailboat'),
              accountEmail: Text('"峨峨楼船夜夜飞，千门万户曈曈发。"',style: TextStyle(fontFamily: "宋体"),),
              currentAccountPicture: Icon(Icons.sailing,size: 60,color: Colors.white,),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.area_chart_outlined),
              title: const Text('数据图表'),
              onTap:  () {
                Navigator.of(context).pop(); // 关闭 drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('数据查看'),
              onTap: _viewBtn,
            ),
            ListTile(
              leading: const Icon(Icons.analytics_outlined),
              title: const Text('数据分析'),
              onTap: _analysisBtn,
            ),
            ListTile(
              leading: const Icon(Icons.document_scanner),
              title: const Text('报告生成'),
              onTap: _wordBtn,
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('系统设置'),
              onTap: _settingBtn,
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('帮助'),
              onTap: _helpBtn,
            ),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ProcessResult result = await Process.run('RTMS.exe', ['arg1', 'arg2']);
        },
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        child: Icon(Icons.sailing,color: Colors.white,),
        tooltip: '实时监测系统',
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
class ChartData {
  ChartData(this.time, this.data);
  final String time;
  final double data;
}