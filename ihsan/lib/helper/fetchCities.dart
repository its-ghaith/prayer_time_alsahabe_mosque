import 'dart:convert';
import 'package:Ihsan/models/Country.dart';
import 'package:Ihsan/providers/radioListTile_cities.dart';
import 'package:Ihsan/widgets/city_lat_lng.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List> fetchCityNames() async {
  var names = await rootBundle
      .loadString('assets/cities/Utx5F8y5kF5cX81AtWEooLY3D3mJUfZ8gLQNgbBs.json')
      .then((value) {
    List countries = jsonDecode(value);
    var c = countries.first;
    Country country = Country.fromJsos(c);
    return country.cities;
  });
  return names;
}

List<Widget> getSettingElements(
    List data) {
  List<Widget> list = [];
  CityLatLng cityLatLng = CityLatLng(data);
  list.add(cityLatLng);
  return list;
}

Future<SharedPreferences> getPreferences() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences;
}
