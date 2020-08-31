import 'package:Ihsan/constant.dart';
import 'package:Ihsan/localization/demo_localization.dart';
import 'package:Ihsan/providers/radioListTile_cities.dart';
import 'package:Ihsan/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  bool localeLoaded = false;

  @override
  void initState() {
    super.initState();
    this._fetchLocale().then((locale) {
      setState(() {
        this.localeLoaded = true;
        this._locale = locale;
      });
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
      this.localeLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (this.localeLoaded == false) {
      return CircularProgressIndicator();
    } else
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) {
              return RadioListTileCitiesProvider();
            },
          )
        ],
        child: MaterialApp(
          locale: _locale,
          supportedLocales: [
            Locale("en", "US"),
            Locale("de", "DE"),
            Locale("ar", "AE"),
          ],
          localizationsDelegates: [
            DemoLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            for (var locale in supportedLocales) {
              if (locale.languageCode == deviceLocale.languageCode &&
                  locale.countryCode == deviceLocale.countryCode) {
                return deviceLocale;
              }
            }
            return supportedLocales.first;
          },
          debugShowCheckedModeBanner: false,
          title: 'ihsan',
          theme: ThemeData(
              scaffoldBackgroundColor: kBackgroundColor,
              fontFamily: "Cairo",
              textTheme: TextTheme(body1: TextStyle(color: kBodyTextColor))),
          home: SettingScreen(),
        ),
      );
  }

  _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      return null;
    }
    return Locale(
        prefs.getString('language_code'), prefs.getString('country_code'));
  }
}
