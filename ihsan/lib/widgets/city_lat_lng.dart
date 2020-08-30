import 'dart:convert';
import 'package:Ihsan/models/City.dart';
import 'package:Ihsan/providers/radioListTile_cities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CityLatLng extends StatefulWidget {
  City _city ;
  CityLatLng(this._city);
  City get city => _city;

  set city(City value) {
    _city = value;
  }

  @override
  _CityLatLngState createState() => _CityLatLngState(city);
}

class _CityLatLngState extends State<CityLatLng> {
  City _city;
  Text _text;

  _CityLatLngState(City city){
    this._city=city;
    _text= Text(city.city);
  }

  setSelectedRadioCity(String val, RadioListTileCitiesProvider bloc) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("city", jsonEncode(_city));
    bloc.selectedCity = val;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<RadioListTileCitiesProvider>(context);
    Selector<RadioListTileCitiesProvider, String> selector = Selector(
      selector: (context, provs1) => provs1.selectedCity,
      builder: (context, provonr, child) {
        return ListTile(
          title: Text(_city.city),
          leading: Radio(
              value: this._city.city,
              groupValue: bloc.selectedCity,
              onChanged: (val) {
                setSelectedRadioCity(val, bloc);
              })
        );
      },
    );
    return selector ;
  }
}
