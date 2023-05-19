import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class lineChart{

  List<FlSpot> data = [
    FlSpot(0, 3),
    FlSpot(1, 5),
    FlSpot(2, 6),
    FlSpot(3, 4),
    FlSpot(4, 7),
    FlSpot(5, 3),
    FlSpot(6, 5),
    FlSpot(7, 6),
    FlSpot(8, 4),
    FlSpot(9, 7),
    FlSpot(10, 3),
  ];

  LineChartBarData get lineChartBarData => LineChartBarData(
    isCurved: true,
    barWidth: 3,
    isStrokeCapRound: false,
    dotData: FlDotData(show: false),
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


  LineChartData sampleData() {
    return LineChartData(
      //? 是否可以点击
      lineTouchData: LineTouchData(
          enabled:true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.white,

          )
      ),
      //? 网格线配置
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
                    child: Text(value.toString() + '年月日'),
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
}
