import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

class lineChart{

  late sqlite.Database database;

  List<FlSpot> data = [];
  List<Map<String, dynamic>> dataList = [];

  LineChartBarData get lineChartBarData => LineChartBarData(
    isCurved: true,
    color: Colors.blue,
    barWidth: 3,
    isStrokeCapRound: false,
    dotData: FlDotData(show: true),
    belowBarData: BarAreaData(show: false),
    isStepLineChart:false,
    spots: data,
  );

  double getMaxY(List<FlSpot> data) {
    double max = -1;
    for (FlSpot spot in data) {
      if (spot.y > max) {
        max = spot.y;
      }
    }
    return max + 4; // 添加一些空余的空间可改变上下边界
  }

  double getMinY(List<FlSpot> data){
    double min = getMaxY(data);
    for(FlSpot spot in data){
      if(spot.y < min){
        min = spot.y;
      }
    }
    return min - 4;
  }

  double getMaxX(List<FlSpot> data) {
    double max = -1;
    for (FlSpot spot in data) {
      if (spot.x > max) {
        max = spot.x;
      }
    }
    return max + 1; // 添加一些空余的空间可改变上下边界
  }

  double getMinX(List<FlSpot> data){
    double min = getMaxY(data);
    for(FlSpot spot in data){
      if(spot.x < min){
        min = spot.x;
      }
    }
    return min - 1;
  }

  int getNum(List<FlSpot> data){
    int number = 0;
    for(FlSpot spot in data){
      number++;
    }
    if(number>=25){
      return 25;
    }
    return number;
  }
  List<LineChartBarData> get lineBarsData => [
    lineChartBarData,
  ];


  LineChartData sampleData(List<FlSpot> data_,List<Map<String, dynamic>> chartList) {
    data.clear();dataList.clear();
    data = data_;dataList = chartList;
    return LineChartData(
      lineTouchData: LineTouchData(
          enabled:true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.white,
          ),
      ),
      minY: getMinY(data),
      maxY: getMaxY(data),
      gridData: FlGridData(
        show: true,
      ),
      titlesData: FlTitlesData(
        show: true,
        topTitles: AxisTitles(
            axisNameWidget: Text('',)
        ),
        rightTitles: AxisTitles(
            axisNameWidget: Text('',)
        ),
        bottomTitles:AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget:(value,data_) {
                return Row(
                  children: [
                    Transform(
                      transform: Matrix4.rotationZ(getNum(data).toDouble()*0.05), // 将文本向右倾斜10度
                      child: Text(dataInit(value)),
                    )
                  ],
                );
              }
          ),

        ),
      ),
      clipData:FlClipData(
        top: false,
        bottom: true,
        left: true,
        right: false,
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1,
          ),
          left:BorderSide(
            color: Colors.black,
            width: 1,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),

        ),
      ),
      lineBarsData: lineBarsData,
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
      case '温度': {
        return "temperature";
      } break;
      case "PH值": {
        return "PH";
      } break;
      case '电导率': {
        return "electrical";
      } break;
      case "溶解氧": {
        return "O2";
      } break;
      case '浊度': {
        return "dirty";
      } break;
      case "叶绿素": {
        return "green";
      } break;
      case "氨氮": {
        return "NHN";
      } break;
      case "水中油": {
        return "oil";
      } break;
    }
    return "";
  }
  String dataInit(double x){
    int number = x.toInt();
    return dataList[number]['time'];
  }
}
