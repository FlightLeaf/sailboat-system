import 'dart:convert';
/// O2 : 15.6
/// PH : 7.35
/// NHN : 15.2
/// oil : 15.6
/// time : "2023-03-24"
/// dirty : 12.6
/// green : 19.3
/// place : "Qingdao"
/// latitude : "37"
/// longitude : "34"
/// electrical : 7.1
/// temperature : 15.27272727

// To parse this JSON data, do
//
//     final waterData = waterDataFromJson(jsonString);

WaterData waterDataFromJson(String str) => WaterData.fromJson(json.decode(str));

String waterDataToJson(WaterData data) => json.encode(data.toJson());

class WaterData {

  String time;
  String longitude;
  String latitude;
  String place;
  double temperature;
  double ph;
  double electrical;
  double o2;
  double dirty;
  double green;
  double nhn;
  double oil;
  String target;
  bool selected;

  WaterData({
    required this.time,
    required this.longitude,
    required this.latitude,
    required this.place,
    required this.temperature,
    required this.ph,
    required this.electrical,
    required this.o2,
    required this.dirty,
    required this.green,
    required this.nhn,
    required this.oil,
    required this.target,
    this.selected = false
  });

  factory WaterData.fromJson(Map<String, dynamic> json) => WaterData(
    time: json["time"],
    longitude: json["longitude"],
    latitude: json["latitude"],
    place: json["place"],
    temperature: json["temperature"],
    ph: json["PH"],
    electrical: json["electrical"],
    o2: json["O2"],
    dirty: json["dirty"],
    green: json["green"],
    nhn: json["NHN"],
    oil: json["oil"],
    target: json["target"],
    //selected: json["select"],
  );

  Map<String, dynamic> toJson() => {
    "time": time,
    "longitude": longitude,
    "latitude": latitude,
    "place": place,
    "temperature": temperature,
    "PH": ph,
    "electrical": electrical,
    "O2": o2,
    "dirty": dirty,
    "green": green,
    "NHN": nhn,
    "oil": oil,
    "target": target,
    "selected":selected,
  };

  List<Map<String, dynamic>> toList() => [
    {'time': time},
    {'longitude': longitude},
    {'latitude': latitude},
    {'place': place},
    {'temperature': temperature},
    {'PH': ph},
    {'electrical': electrical},
    {'O2': o2},
    {'dirty': dirty},
    {'green': green},
    {'NHN': nhn},
    {'oil': oil},
    {'target': target},
    {'selected': selected},
  ];
}
