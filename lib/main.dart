import 'package:flutter/material.dart';
import 'package:sailboatsystem/pages/HomePage.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;
import 'package:provider/provider.dart';

import 'models/ThemeColor.dart';

void main() {
  runApp(MyApp());
}
/*
 * TODO 数据库替换 SQLite=>MySQL
 * */
int colorNum = 0;
bool dark_light = false;

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> theme = [];

    sqlite.Database database;
    database = sqlite.sqlite3.open('sailboat.sqlite');
    theme = database.select('SELECT * FROM Settings');
    colorNum = theme[0]['Theme'];
    if(theme[0]['dark_light'].toString() == '0') {
      dark_light = false;
    } else {
      dark_light = true;
    }
    database.dispose();
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) => MaterialApp(
          title: 'Flutter',
          theme: theme.getTheme(),
          home: const MyHomePage(title: '基于无人帆船的水质监测数据管理系统'),
        ),
      ),
    );
  }
}

class ThemeProvider with ChangeNotifier {
  ThemeData themeData = dark_light ? darkTheme : lightTheme;
  bool isDarkMode = dark_light;
  int _colorNum = 0;

  ThemeData getTheme() => themeData;

  void setTheme(bool theme) {
    isDarkMode = theme;
    themeData = isDarkMode ? darkTheme : lightTheme;
    notifyListeners();
  }

  int get colorNum => _colorNum;

  set colorNum(int number) {
    _colorNum = number;
    themeData = ThemeData(
      brightness: themeData.brightness,
      primaryColor: themeList[_colorNum],
      useMaterial3: true,
      fontFamily:"黑体",
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
    notifyListeners();
  }
}


final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: themeList[colorNum],
  useMaterial3: true,
  fontFamily:"黑体",
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: themeList[colorNum],
  useMaterial3: true,
  fontFamily:"黑体",
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
