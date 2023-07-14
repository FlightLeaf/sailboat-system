import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sailboatsystem/pages/FishPage.dart';
import 'package:sailboatsystem/pages/OsPage.dart';
import 'package:sailboatsystem/pages/PlacePage.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:syncfusion_flutter_charts/charts.dart';

import '../service/util.dart';
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

  String? startValue,placeValue,endValue,dataValue;

  List<String> placeItems = [];
  List<String> startItems = [];
  List<String> endItems = [];
  List<String> dataItems = [];

  GlobalKey chart = GlobalKey();

  List<Map<String, dynamic>> chartListResult = [];

  List<ChartData> chartList = [];

  bool _state = false;

  String name = '目标';

  void _databaseTools(String dataValue,String place,String start,String end){
    chartList.clear();
    database = sqlite.sqlite3.open('sailboat.sqlite');
    name = dataValue;
    dataValue = exchangeData(dataValue);
    chartListResult = database.select('SELECT time,$dataValue FROM water_data where place = \'$place\' and time between \'$start\' and \'$end\'  ORDER BY time ASC');
    for (var i = 0; i < chartListResult.length; i++) {
      double water = chartListResult[i][dataValue];
      String time = chartListResult[i]['time'];
      chartList.add(ChartData(time, water));
    }
    database.dispose();
  }

  @override
  void initState() {
    super.initState();
    database = sqlite.sqlite3.open('sailboat.sqlite');
    nameList = database.select('SELECT name FROM dataState where state = \'1\' and special = \'1\'');
    for (var i = 0; i < nameList.length; i++) {
      String name = nameList[i]['name'];
      dataItems.add(name);
    }
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
    var place = database.select('select place from water_data order by time desc limit 1');
    var start = database.select('select time from water_data order by time asc limit 1');
    var end = database.select('select time from water_data order by time desc limit 1');
    _databaseTools('温度(℃)', place[0]['place'], start[0]['time'], end[0]['time']);
    _state = true;
  }


  final PageController pageController = PageController(initialPage: 0);

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
              const SizedBox(width: 30.0),
              Expanded(
                flex: 2,
                child: DropdownButton<String>(
                  hint: Text('选择地址',),
                  focusColor: Colors.white.withOpacity(0.0),
                  value: placeValue,
                  onChanged: (String? newValue) {
                    // 更新下拉框的值
                    setState(() {
                      placeValue = newValue!;
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
              const SizedBox(width: 5.0),
              Expanded(
                flex: 2,
                child: DropdownButton<String>(
                  hint: Text('测量项目',),
                  focusColor: Colors.white.withOpacity(0.0),
                  value: dataValue,
                  onChanged: (String? newValue) {
                    // 更新下拉框的值
                    setState(() {
                      dataValue = newValue!;
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
              const SizedBox(width: 5.0),
              Expanded(
                flex: 2,
                child: DropdownButton<String>(
                  hint: Text('开始时间',),
                  focusColor: Colors.white.withOpacity(0.0),
                  value: startValue,
                  onChanged: (String? newValue) {
                    // 更新下拉框的值
                    setState(() {
                      startValue = newValue!;
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
              const SizedBox(width: 5.0),
              Expanded(
                flex: 2,
                child: DropdownButton<String>(
                  hint: Text('结束时间',),
                  focusColor: Colors.white.withOpacity(0.0),
                  value: endValue,
                  onChanged: (String? newValue){
                    setState(() {
                      endValue = newValue!;
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
              const SizedBox(width: 5.0),
              Expanded(
                flex: 1,
                child: TextButton.icon(
                  onPressed: () {
                    _databaseTools(dataValue!, placeValue!, startValue!, endValue!);
                    setState(() {
                      _state = true;
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  icon: Icon(Icons.search,color: Colors.white,),
                  label: const Text('查 询',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                ),
              ),
              const SizedBox(width: 30.0),
            ],
          ),),
          const Divider(),
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
                      title: ChartTitle(text: '$name水质数据图表'),
                      legend: Legend(isVisible: true),
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                        shared:true,
                      ),
                      series: <LineSeries<ChartData, String>>[
                        LineSeries<ChartData, String>(
                          name: name,
                          dataSource:  chartList,
                          xValueMapper: (ChartData chartData, _) => chartData.time,
                          yValueMapper: (ChartData chartData, _) => chartData.data,
                          dataLabelSettings: const DataLabelSettings(isVisible: true),
                          color: Colors.blue,
                          width:3,
                          markerSettings: const MarkerSettings(borderColor: Colors.blueAccent,isVisible: true),
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
          const Expanded(
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
              accountName: const Text('Unmanned sailboat'),
              accountEmail: const Text('"峨峨楼船夜夜飞，千门万户曈曈发。"',style: TextStyle(fontFamily: "宋体"),),
              currentAccountPicture: const Icon(Icons.sailing,size: 60,color: Colors.white,),
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
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics_outlined),
              title: const Text('数据分析'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AnalysisPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.document_scanner),
              title: const Text('报告生成'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => WordPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.water),
              title: const Text('海水水质标准'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => OsPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.landscape),
              title: const Text('地表水环境质量标准'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => PlacePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.food_bank),
              title: const Text('渔业水质标准'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => FishPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('系统设置'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('帮助'),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => HelpPage()));
              },
            ),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Process.run('RTMS.exe', ['arg1', 'arg2']);
        },
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        tooltip: '实时监测系统',
        child: const Icon(Icons.sailing,color: Colors.white,),
      ),
    );
  }
}
class ChartData {
  ChartData(this.time, this.data);
  final String time;
  final double data;
}