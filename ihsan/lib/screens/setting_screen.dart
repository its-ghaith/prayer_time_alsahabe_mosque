import 'dart:convert';
import 'package:Ihsan/helper/fetchCities.dart';
import 'package:Ihsan/localization/demo_localization.dart';
import 'package:Ihsan/localization/localization_constants.dart';
import 'package:Ihsan/main.dart';
import 'package:Ihsan/models/Language.dart';
import 'package:Ihsan/providers/radioListTile_cities.dart';
import 'package:Ihsan/screens/prayer_time_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(getTrabskated(context, "Settings page")),
              actions: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: DropdownButton(
                    onChanged: (lang) {
                      _changeLanguage(lang);
                    },
                    underline: SizedBox(),
                    items: Language.languageList()
                        .map<DropdownMenuItem<Language>>(
                            (lang) => DropdownMenuItem(
                                value: lang,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [Text(lang.flag), Text(lang.name)],
                                )))
                        .toList(),
                    icon: Icon(
                      Icons.language,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            body: IntroductionScreen(
              pages: [
                PageViewModel(
                    titleWidget: Padding(
                      padding: EdgeInsets.only(top: 0),
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
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
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
                    getTrabskated(context, "Done"),
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ],
              ),
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

  void _changeLanguage(Language lang) async {
    Locale _temp;
    switch (lang.languageCode) {
      case 'en':
        {
          _temp = Locale(lang.languageCode, 'US');
        }
        break;
      case 'de':
        {
          _temp = Locale(lang.languageCode, 'DE');
        }
        break;
      case 'ar':
        {
          _temp = Locale(lang.languageCode, 'AE');
        }
        break;
      default:
        _temp = Locale(lang.languageCode, 'US');
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("language_code", _temp.languageCode);
    preferences.setString("country_code", _temp.countryCode);
    MyApp.setLocale(context, _temp);
  }
}
