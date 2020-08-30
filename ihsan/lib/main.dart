import 'package:Ihsan/constant.dart';
import 'package:Ihsan/providers/radioListTile_cities.dart';
import 'package:Ihsan/screens/city_chose.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return RadioListTileCitiesProvider();
          },
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ihsan',
          theme: ThemeData(
              scaffoldBackgroundColor: kBackgroundColor,
              fontFamily: "Cairo",
              textTheme: TextTheme(body1: TextStyle(color: kBodyTextColor))),
          home: CityChose()),
    );
  }
}


//import 'package:adhan/adhan.dart';
//import 'package:intl/intl.dart';
//
//main() {
//  print('My Prayer Times');
//  final myCoordinates = Coordinates(51.848277, 12.229065); // Replace with your own location lat, lng.
//  final params = CalculationMethod.umm_al_qura.getParameters();
//  params.madhab = Madhab.hanafi;
//  final prayerTimes = PrayerTimes.today(myCoordinates, params);
//
//  print("---Today's Prayer Times in Your Local Timezone(${prayerTimes.fajr.timeZoneName})---");
//  print(DateFormat.Hm().format(prayerTimes.fajr));
//  print(DateFormat.Hm().format(prayerTimes.sunrise));
//  print(DateFormat.Hm().format(prayerTimes.dhuhr));
//  print(DateFormat.Hm().format(prayerTimes.asr));
//  print(DateFormat.Hm().format(prayerTimes.maghrib));
//  print(DateFormat.Hm().format(prayerTimes.isha));
//
//  print('---');
//
//
//}
