import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  _helpState createState() => _helpState();
}

class _helpState extends State<HelpPage> {
  final channel = IOWebSocketChannel.connect('ws://101.42.163.213:88');
  List<ChartData> chartList = [];
  bool _state = true;
  int i = 0;
  @override
  void initState() {
    super.initState();
    channel.stream.listen((message) {
      i++;
      setState(() {
        final json = jsonDecode(message);
        final now = DateTime.now();
        final hour = now.hour;
        final minute = now.minute;
        final second = now.second;
        final year = now.year;
        final month = now.month;
        final day = now.day;
        json['time'] = '$year.$month.$day.$hour.$minute.$second';
        print('Received message from server: $message');
        chartList.add(ChartData.fromJson(json));
        if(i>7){
          _state = true;
          chartList.removeAt(0);
        }
      });
    }, onError: (error) {
      print('Error: ${error.toString()}');
    }, onDone: () {
      print('Connection closed.');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('帮助'),
      ),
      body: SingleChildScrollView(
        child: _state?SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: '水质数据图表'),
            legend: Legend(isVisible: true),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              shared:true,
            ),
            series: <LineSeries<ChartData, String>>[
              LineSeries<ChartData, String>(
                name: '数据',
                dataSource:  chartList,
                xValueMapper: (ChartData sales, _) => sales.time,
                yValueMapper: (ChartData sales, _) => sales.data,
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
    );
  }

  @override
  void dispose() {
    super.dispose();
    // 关闭 WebSocket 连接
    channel.sink.close();
  }
}

class ChartData {
  //ChartData(this.time, this.data);
  final String time;
  final double data;
  ChartData({
    required this.time,
    required this.data
  });
  factory ChartData.fromJson(Map<String, dynamic> json) => ChartData(
    time: json["time"],
    data: double.parse(json["dirty"].toString()),
    //selected: json["select"],
  );
}
