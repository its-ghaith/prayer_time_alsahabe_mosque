import 'dart:convert';

import 'package:Ihsan/helper/fetchCities.dart';
import 'package:Ihsan/providers/radioListTile_cities.dart';
import 'package:Ihsan/screens/prayer_time_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';

class CityChose extends StatefulWidget {
  @override
  _CityChoseState createState() => _CityChoseState();
}

class _CityChoseState extends State<CityChose> {
  Future<List> futureList;
  Future<SharedPreferences> futurePreferences;

  @override
  void initState() {
    super.initState();
    futureList = fetchCityNames();
    futurePreferences = getPreferences();
  }

  setIsCitySetted() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("isCitySetted", true);
  }

  dynamic _onDone(context, RadioListTileCitiesProvider bloc) async {
    if (bloc.selectedCity != null) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("city", jsonEncode(bloc.selectedCity));
      setIsCitySetted();
      return Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PrayerTimeScreen()),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<RadioListTileCitiesProvider>(context);
    return FutureBuilder(
      future: futurePreferences,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool isCitySetted = snapshot.data.getBool("isCitySetted");
          if (isCitySetted != null && isCitySetted) {
            return PrayerTimeScreen();
          }
          return IntroductionScreen(
            pages: [
              PageViewModel(
                  titleWidget: Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text("يرجى اختيار المدينة"),
                  ),
                  bodyWidget: FutureBuilder(
                    future: futureList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: getSettingElements(snapshot.data),
                        );
                      }
                      return Center(
                          child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ));
                    },
                  )),
            ],
            onDone: () => _onDone(context, bloc),
            done: ButtonBar(
              buttonHeight: 30,
              buttonMinWidth: 50,
              alignment: MainAxisAlignment.center,
              children: [
                Text(
                  "تم",
                  style: TextStyle(color: kPrimaryColor),
                ),
              ],
            ),
          );
        }
        return Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ));
      },
    );
  }
}
