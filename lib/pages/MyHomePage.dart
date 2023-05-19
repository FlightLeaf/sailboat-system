
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/WaterData.dart';
import 'AnalysisPage.dart';
import 'HelpPage.dart';
import 'SettingPage.dart';
import 'ViewPage.dart';
import 'WordPage.dart';
import 'lineChart.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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

  var place_value,data_value,start_value,end_value;

  final PageController pageController = PageController(initialPage: 0);

  WaterData waterData = WaterData.fromJson({"O2": 15.6, "PH": 7.35, "NHN": 15.2, "oil": 15.6, "time": "2023-03-24", "dirty": 12.6, "green": 19.3, "place": "Qingdao", "latitude": "37", "longitude": "34", "electrical": 7.1, "temperature": 15.27272727});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title,style: const TextStyle(fontFamily: '黑体',),),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Center(
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Expanded(
                  flex:5,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('选择查看条件',style: TextStyle(fontSize: 20,fontFamily: '黑体'),),
                        Container(
                          height: 40,
                        ),
                        ListTile(
                          title: const Text('测量项目：',style: TextStyle(fontStyle: FontStyle.normal,),),
                          trailing:
                          DropdownButton<String>(
                            focusColor: Colors.white.withOpacity(0.0),
                            value: data_value,
                            onChanged: (String? newValue) {
                              // 更新下拉框的值
                              setState(() {
                                data_value = newValue!;
                              });
                            },
                            items:
                            <String>['Option 1', 'Option 2', 'Option 3', 'Option 4'].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          height: 10,
                        ),
                        ListTile(
                          title: const Text('地区：',style: TextStyle(fontStyle: FontStyle.normal,),),
                          trailing:
                          DropdownButton<String>(
                            focusColor: Colors.white.withOpacity(0.0),
                            value: place_value,
                            onChanged: (String? newValue) {
                              // 更新下拉框的值
                              setState(() {
                                place_value = newValue!;
                              });
                            },
                            items: <String>['Option 1', 'Option 2', 'Option 3', 'Option 4']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          height: 10,
                        ),
                        ListTile(
                          title: const Text('开始时间：',style: TextStyle(fontStyle: FontStyle.normal,),),
                          trailing:
                          DropdownButton<String>(
                            focusColor: Colors.white.withOpacity(0.0),
                            value: start_value,
                            onChanged: (String? newValue) {
                              // 更新下拉框的值
                              setState(() {
                                start_value = newValue!;
                              });
                            },
                            items: <String>['Option 1', 'Option 2', 'Option 3', 'Option 4']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          height: 10,
                        ),
                        ListTile(
                          title: const Text('截止时间：',style: TextStyle(fontStyle: FontStyle.normal,),),
                          trailing:
                          DropdownButton<String>(
                            focusColor: Colors.white.withOpacity(0.0),
                            value: end_value,
                            onChanged: (String? newValue){
                              setState(() {
                                end_value = newValue!;
                              });
                            },
                            items: <String>['Option 1', 'Option 2', 'Option 3', 'Option 4']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          height: 10,
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            minimumSize: Size(200, 40),
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text('查询',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 12,
            child: Column(
              children: [
                Expanded(flex:1,child: Center(),),
                Expanded(
                  flex: 8,
                    child:LineChart(
                        lineChart().sampleData()
                    ),
                  ),
                Expanded(flex:2,child: Center(),),
              ],
            ),
          ),
          Expanded(
            flex: 1,
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
    );
  }
}
