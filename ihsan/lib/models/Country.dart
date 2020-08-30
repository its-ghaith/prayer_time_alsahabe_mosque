import 'dart:convert';

import 'package:Ihsan/models/City.dart';

class Country {
  String _country;
  String _iso2;
  List<City> _cities= List();

  Country(this._country, this._iso2, this._cities);

  Country.fromJsos(Map json) {
    _country = json["country"];
    _iso2 = json["iso2"];
    List list = json["cities"] as List;
    list.forEach((element) {
      String name = element['city'];
      double lat = double.parse(element['lat']);
      double lng = double.parse(element['lng']);
      _cities.add(City(name, lat, lng));
    });
  }

  Map toJson() => {"country": country, "iso2": iso2, "cities": cities};

  List<City> get cities => _cities;

  set cities(List<City> value) {
    _cities = value;
  }

  String get iso2 => _iso2;

  set iso2(String value) {
    _iso2 = value;
  }

  String get country => _country;

  set country(String value) {
    _country = value;
  }
}
