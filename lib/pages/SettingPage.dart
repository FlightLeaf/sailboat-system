import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import '../main.dart';

class SettingPage extends StatefulWidget{
  @override
  _SettingPage createState() => _SettingPage();
}


class _SettingPage extends State<SettingPage>{

  String data_value = '简体中文';
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
    if(color == '粉色'){
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
      return '粉色';
    }
    return '蓝色';
  }

  late sqlite.Database database;

  @override
  void initState() {
    super.initState();
    database = sqlite.sqlite3.open('sailboat.sqlite');
    List<Map<String, dynamic>> theme = [];
    theme = database.select('SELECT theme FROM Settings');
    color_value = Exchangecolor(theme[0]['Theme']);
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
                      <String>['蓝色', '浅蓝色','绿色','粉色'].map<DropdownMenuItem<String>>((String value) {
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
                    title: Text('夜间模式'),
                    trailing: Switch(
                      value: switchValue,
                      onChanged: (value){
                        setState(() {
                          switchValue = !switchValue;
                        });
                      },
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: const Text('语言'),
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
                      <String>['简体中文', 'English'].map<DropdownMenuItem<String>>((String value) {
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
            Expanded(flex:2,child: Container()),
          ],
        )
    );
  }
}