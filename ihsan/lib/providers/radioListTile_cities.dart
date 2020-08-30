import 'package:Ihsan/models/City.dart';
import 'package:flutter/cupertino.dart';

class RadioListTileCitiesProvider with ChangeNotifier{
  City _selectedCity;

  City get selectedCity => _selectedCity;

  set selectedCity(City value) {
    _selectedCity = value;
    notifyListeners();
  }
}