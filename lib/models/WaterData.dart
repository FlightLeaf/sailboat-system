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

WaterData waterDataFromJson(String str) => WaterData.fromJson(json.decode(str));
String waterDataToJson(WaterData data) => json.encode(data.toJson());
class WaterData {
  WaterData({
      num? o2, 
      num? ph, 
      num? nhn, 
      num? oil, 
      String? time, 
      num? dirty, 
      num? green, 
      String? place, 
      String? latitude, 
      String? longitude, 
      num? electrical, 
      num? temperature,}){
    _o2 = o2;
    _ph = ph;
    _nhn = nhn;
    _oil = oil;
    _time = time;
    _dirty = dirty;
    _green = green;
    _place = place;
    _latitude = latitude;
    _longitude = longitude;
    _electrical = electrical;
    _temperature = temperature;
}

  WaterData.fromJson(dynamic json) {
    _o2 = json['O2'];
    _ph = json['PH'];
    _nhn = json['NHN'];
    _oil = json['oil'];
    _time = json['time'];
    _dirty = json['dirty'];
    _green = json['green'];
    _place = json['place'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _electrical = json['electrical'];
    _temperature = json['temperature'];
  }
  num? _o2;
  num? _ph;
  num? _nhn;
  num? _oil;
  String? _time;
  num? _dirty;
  num? _green;
  String? _place;
  String? _latitude;
  String? _longitude;
  num? _electrical;
  num? _temperature;
WaterData copyWith({  num? o2,
  num? ph,
  num? nhn,
  num? oil,
  String? time,
  num? dirty,
  num? green,
  String? place,
  String? latitude,
  String? longitude,
  num? electrical,
  num? temperature,
}) => WaterData(  o2: o2 ?? _o2,
  ph: ph ?? _ph,
  nhn: nhn ?? _nhn,
  oil: oil ?? _oil,
  time: time ?? _time,
  dirty: dirty ?? _dirty,
  green: green ?? _green,
  place: place ?? _place,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
  electrical: electrical ?? _electrical,
  temperature: temperature ?? _temperature,
);
  num? get o2 => _o2;
  num? get ph => _ph;
  num? get nhn => _nhn;
  num? get oil => _oil;
  String? get time => _time;
  num? get dirty => _dirty;
  num? get green => _green;
  String? get place => _place;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  num? get electrical => _electrical;
  num? get temperature => _temperature;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['O2'] = _o2;
    map['PH'] = _ph;
    map['NHN'] = _nhn;
    map['oil'] = _oil;
    map['time'] = _time;
    map['dirty'] = _dirty;
    map['green'] = _green;
    map['place'] = _place;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['electrical'] = _electrical;
    map['temperature'] = _temperature;
    return map;
  }

}