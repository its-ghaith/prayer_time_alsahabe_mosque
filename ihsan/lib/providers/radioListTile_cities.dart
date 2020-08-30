import 'package:flutter/cupertino.dart';

class RadioListTileCitiesProvider with ChangeNotifier{
  String _selectedCity = "";

  String get selectedCity => _selectedCity;

  set selectedCity(String value) {
    _selectedCity = value;
    notifyListeners();
  }
}