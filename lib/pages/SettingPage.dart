import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import '../main.dart';
import '../service/util.dart';

class SettingPage extends StatefulWidget{
  @override
  _SettingPage createState() => _SettingPage();
}


class _SettingPage extends State<SettingPage>{

  bool? temp_isSelected = false;
  bool? ph_isSelected = false;
  bool? ele_isSelected = false;
  bool? O2_isSelected = false;
  bool? dirty_isSelected = false;
  bool? green_isSelected = false;
  bool? NHN_isSelected = false;
  bool? oil_isSelected = false;

  bool switchValue = true;
  String? color_value;
  var color_no;


  int colorExchange(var color){
    if(color == '蓝色'){
      return 0;
    }
    if(color == '浅蓝色'){
      return 1;
    }
    if(color == '绿色'){
      return 2;
    }
    if(color == '橙色'){
      return 3;
    }
    return 0;
  }

  String Exchangecolor(int color){
    if(color == 0){
      return '蓝色';
    }
    if(color == 1){
      return '浅蓝色';
    }
    if(color == 2){
      return '绿色';
    }
    if(color == 3){
      return '橙色';
    }
    return '蓝色';
  }

  late sqlite.Database database;

  @override
  void initState() {
    super.initState();
    database = sqlite.sqlite3.open('sailboat.sqlite');
    List<Map<String, dynamic>> theme = [];
    List<Map<String, dynamic>> select = [];
    theme = database.select('SELECT theme FROM Settings');
    select = database.select('SELECT * FROM dataState');
    color_value = Exchangecolor(theme[0]['Theme']);
    for(int i = 0;i<select.length;i++){
      switch(exchangeData(select[i]['name'])){
        case 'temperature':
          if(select[i]['state'].toString() == '1'){
            temp_isSelected = true;
          }
        case 'PH':
          if(select[i]['state'].toString() == '1'){
            ph_isSelected = true;
          }
        case 'electrical':
          if(select[i]['state'].toString() == '1'){
            ele_isSelected = true;
          }
        case 'O2':
          if(select[i]['state'].toString() == '1'){
            O2_isSelected = true;
          }
        case 'dirty':
          if(select[i]['state'].toString() == '1'){
            dirty_isSelected = true;
          }
        case 'green':
          if(select[i]['state'].toString() == '1'){
            green_isSelected = true;
          }
        case 'NHN':
          if(select[i]['state'].toString() == '1'){
            NHN_isSelected = true;
          }
        case 'oil':
          if(select[i]['state'].toString() == '1'){
            oil_isSelected = true;
          }
      }
    }
  }

  void ThemeSet(String value){
    color_no = colorExchange(value);
    database.execute('update Settings SET Theme = '+color_no.toString()+' WHERE NO = 1');
    //database.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('系统设置'),
        ),
        body:Row(
          children: [
            Expanded(flex: 2,child: Container()),
            Expanded(
              flex: 5,
              child:
              ListView(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                children: [
                  ListTile(
                    title: Text('夜间模式'),
                    trailing: Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        themeProvider.setTheme(value);
                        if(value){
                          database.execute('update Settings SET dark_light = \'1\' WHERE NO = 1');
                        }
                        else{
                          database.execute('update Settings SET dark_light = \'0\' WHERE NO = 1');
                        }
                      },
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: const Text('主题颜色'),
                    trailing:
                    DropdownButton<String>(
                      focusColor: Colors.white.withOpacity(0.0),
                      value: color_value,
                      onChanged: (String? newValue) {
                        // 更新下拉框的值
                        setState(() {
                          color_value = newValue!;
                          ThemeSet(color_value!);
                          themeProvider.colorNum = colorExchange(color_value);
                        });
                      },
                      items:
                      <String>['蓝色', '浅蓝色','绿色','橙色'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Divider(),
                ],
              ),
            ),
            Expanded(flex:1,child: Container(),),
            Expanded(
              flex: 5,
              child:
              ListView(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                children: [
                  ListTile(
                    title: Text('可测量元素：'),
                  ),
                  Divider(),
                  ListTile(
                    title: Text('温度'),
                    trailing: Checkbox(
                      activeColor: Colors.blue, // 设置复选框激活时的颜色
                      checkColor: Colors.white, // 设置勾选标记的颜色
                      value: temp_isSelected,
                      onChanged: (newValue) {
                        setState(() {
                          temp_isSelected = newValue;
                          var states = '0';
                          if(newValue == true){
                            states = '1';
                          }
                          database.execute('UPDATE dataState set state = \''+states+'\' WHERE name = \'温度(℃)\'');
                        });
                      },
                    )
                  ),
                  ListTile(
                      title: Text('PH值'),
                      trailing: Checkbox(
                        activeColor: Colors.blue, // 设置复选框激活时的颜色
                        checkColor: Colors.white, // 设置勾选标记的颜色
                        value: ph_isSelected,
                        onChanged: (newValue) {
                          setState(() {
                            ph_isSelected = newValue;
                            var states = '0';
                            if(newValue == true){
                              states = '1';
                            }
                            database.execute('UPDATE dataState set state = \''+states+'\' WHERE name = \'PH值\'');
                          });
                        },
                      )
                  ),
                  ListTile(
                      title: Text('电导率'),
                      trailing: Checkbox(
                        activeColor: Colors.blue, // 设置复选框激活时的颜色
                        checkColor: Colors.white, // 设置勾选标记的颜色
                        value: ele_isSelected,
                        onChanged: (newValue) {
                          setState(() {
                            ele_isSelected = newValue;
                            var states = '0';
                            if(newValue == true){
                              states = '1';
                            }
                            database.execute('UPDATE dataState set state = \''+states+'\' WHERE name = \'电导率(S/m)\'');
                          });
                        },
                      )
                  ),
                  ListTile(
                      title: Text('溶解氧'),
                      trailing: Checkbox(
                        activeColor: Colors.blue, // 设置复选框激活时的颜色
                        checkColor: Colors.white, // 设置勾选标记的颜色
                        value: O2_isSelected,
                        onChanged: (newValue) {
                          setState(() {
                            O2_isSelected = newValue;
                            var states = '0';
                            if(newValue == true){
                              states = '1';
                            }
                            database.execute('UPDATE dataState set state = \''+states+'\' WHERE name = \'溶解氧(mg/L)\'');
                          });
                        },
                      )
                  ),
                  ListTile(
                      title: Text('浊度'),
                      trailing: Checkbox(
                        activeColor: Colors.blue, // 设置复选框激活时的颜色
                        checkColor: Colors.white, // 设置勾选标记的颜色
                        value: dirty_isSelected,
                        onChanged: (newValue) {
                          setState(() {
                            dirty_isSelected = newValue;
                            var states = '0';
                            if(newValue == true){
                              states = '1';
                            }
                            database.execute('UPDATE dataState set state = \''+states+'\' WHERE name = \'浊度(NTU)\'');
                          });
                        },
                      )
                  ),
                  ListTile(
                      title: Text('叶绿素'),
                      trailing: Checkbox(
                        activeColor: Colors.blue, // 设置复选框激活时的颜色
                        checkColor: Colors.white, // 设置勾选标记的颜色
                        value: green_isSelected,
                        onChanged: (newValue) {
                          setState(() {
                            green_isSelected = newValue;
                            var states = '0';
                            if(newValue == true){
                              states = '1';
                            }
                            database.execute('UPDATE dataState set state = \''+states+'\' WHERE name = \'叶绿素(μg/L)\'');
                          });
                        },
                      )
                  ),
                  ListTile(
                      title: Text('氨氮'),
                      trailing: Checkbox(
                        activeColor: Colors.blue, // 设置复选框激活时的颜色
                        checkColor: Colors.white, // 设置勾选标记的颜色
                        value: NHN_isSelected,
                        onChanged: (newValue) {
                          setState(() {
                            NHN_isSelected = newValue;
                            var states = '0';
                            if(newValue == true){
                              states = '1';
                            }
                            database.execute('UPDATE dataState set state = \''+states+'\' WHERE name = \'氨氮(mg/L)\'');
                          });
                        },
                      )
                  ),
                  ListTile(
                      title: Text('水中油'),
                      trailing: Checkbox(
                        activeColor: Colors.blue, // 设置复选框激活时的颜色
                        checkColor: Colors.white, // 设置勾选标记的颜色
                        value: oil_isSelected,
                        onChanged: (newValue) {
                          setState(() {
                            oil_isSelected = newValue;
                            var states = '0';
                            if(newValue == true){
                              states = '1';
                            }
                            database.execute('UPDATE dataState set state = \''+states+'\' WHERE name = \'水中油(mg/L)\'');
                          });
                        },
                      )
                  ),
                  Divider(),
                  Text('注意：数据图表页面需重启方能生效',style: TextStyle(fontSize: 12),)
                ],
              ),
            ),
            Expanded(flex:2,child: Container()),
          ],
        )
    );
  }

}