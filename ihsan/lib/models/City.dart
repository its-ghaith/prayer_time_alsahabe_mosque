import 'package:adhan/adhan.dart';

class City {
  String _city;
  double _lat;
  double _lng;

  static PrayerTimes PRAYERTIMES;

  City(String city, double lat, double lng) {
    this._city = city;
    this.lat = lat;
    this.lng = lng;
  }

  Map toJson() => {'city': city, 'lat': lat, 'lng': lng};

  City.fromJson(Map json) {
    _city = json["city"];
    _lat = json["lat"];
    _lng = json["lng"];
  }

  double get lng => _lng;

  set lng(double value) {
    _lng = value;
  }

  double get lat => _lat;

  set lat(double value) {
    _lat = value;
  }

  String get city => _city;

  set city(String value) {
    _city = value;
  }
}
