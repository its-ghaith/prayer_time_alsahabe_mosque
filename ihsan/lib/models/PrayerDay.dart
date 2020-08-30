import 'dart:convert';
import 'package:Ihsan/models/City.dart';
import 'package:Ihsan/providers/radioListTile_cities.dart';
import 'package:adhan/adhan.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerDay {
  PrayerTimes _prayerTimes;

  static PrayerDay todayPrayerDay;
  static PrayerDay nextPrayerDay;

  PrayerDay(City city, DateComponents dateComponents,
      {CalculationMethod calculationMethod = CalculationMethod.umm_al_qura,
      Madhab madhab = Madhab.shafi}) {
    final myCoordinates = Coordinates(
        city.lat, city.lng); // Replace with your own location lat, lng.
    final params = calculationMethod.getParameters();
    params.madhab = madhab;
    params.withMethodAdjustments(
        PrayerAdjustments(sunrise: -1, asr: 1, maghrib: 2, isha: 2));
    params.fajrInterval = 100;
    final prayerTimes = PrayerTimes(myCoordinates, dateComponents, params);
    _prayerTimes = prayerTimes;
  }

  Map toJson() => {"date": date, "prayerTimes": jsonEncode(_prayerTimes)};

  static Map<String, dynamic> getDayName(PrayerDay prayerDay) {
    var year = prayerDay._prayerTimes.dateComponents.year;
    var month = prayerDay._prayerTimes.dateComponents.month;
    var day = prayerDay._prayerTimes.dateComponents.day;
    DateTime dateTimeDay = DateTime(year, month, day);
    String dayEn = intl.DateFormat('EEEE').format(dateTimeDay);

    String dayAr = "";
    String dayDe = "";

    switch (dayEn) {
      case "Sunday":
        {
          dayAr = "الأحد";
          dayDe = "Sonntag";
        }
        break;

      case "Monday":
        {
          dayAr = "الإثنين";
          dayDe = "Montag";
        }
        break;

      case "Tuesday":
        {
          dayAr = "الثلاثاء";
          dayDe = "Dienstag ";
        }
        break;

      case "Wednesday":
        {
          dayAr = "الأربعاء";
          dayDe = "Mittwoch";
        }
        break;

      case "Thursday":
        {
          dayAr = "الخميس";
          dayDe = "Donnerstag";
        }
        break;

      case "Friday":
        {
          dayAr = "الجمعة";
          dayDe = "Freitag";
        }
        break;

      case "Saturday":
        {
          dayAr = "السبت";
          dayDe = "Samstag";
        }
        break;
    }

    Map<String, dynamic> names = Map();
    names["ar"] = dayAr;
    names["en"] = dayEn;
    names["de"] = dayDe;

    return names;
  }

  static getNextPrayerTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await setTodayPrayerDay();
    await setNextPrayerDay();

    var arr = [
      todayPrayerDay._prayerTimes.fajr,
      todayPrayerDay._prayerTimes.sunrise,
      todayPrayerDay._prayerTimes.dhuhr,
      todayPrayerDay._prayerTimes.asr,
      todayPrayerDay._prayerTimes.maghrib,
      todayPrayerDay._prayerTimes.isha,
      nextPrayerDay._prayerTimes.fajr
    ];

    final currentTime = DateTime.now();

    if (currentTime.isBefore(arr[0])) {
      preferences.setString("nextPrayerName", "الفجر");
      preferences.setString("nextPrayerTime", arr[0].toIso8601String());
      print("1");
    } else if (currentTime.isAfter(arr[0]) && currentTime.isBefore(arr[1])) {
      preferences.setString("nextPrayerName", "الضحى");
      preferences.setString("nextPrayerTime", arr[1].toIso8601String());
      print("2");
    } else if (currentTime.isAfter(arr[1]) && currentTime.isBefore(arr[2])) {
      preferences.setString("nextPrayerName", "الظهر");
      preferences.setString("nextPrayerTime", arr[2].toIso8601String());
      print("3");
    } else if (currentTime.isAfter(arr[2]) && currentTime.isBefore(arr[3])) {
      preferences.setString("nextPrayerName", "العصر");
      preferences.setString("nextPrayerTime", arr[3].toIso8601String());
      print("4");
    } else if (currentTime.isAfter(arr[3]) && currentTime.isBefore(arr[4])) {
      preferences.setString("nextPrayerName", "المغرب");
      preferences.setString("nextPrayerTime", arr[4].toIso8601String());
      print("5");
    } else if (currentTime.isAfter(arr[4]) && currentTime.isBefore(arr[5])) {
      preferences.setString("nextPrayerName", "العشاء");
      preferences.setString("nextPrayerTime", arr[5].toIso8601String());
      print("6");
    } else if (currentTime.isAfter(arr[5])) {
      preferences.setString("nextPrayerName", "الفجر");
      preferences.setString("nextPrayerTime", arr[6].toIso8601String());
      print("7");
    }
  }

  static Future<PrayerDay> getPrayerDay({int countDay = 0}) async {
    final DateTime now = DateTime.now();
    final DateTime date = now.add(Duration(days: countDay));
    final DateComponents dateComponents =
        DateComponents(date.year, date.month, date.day);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    City city = City.fromJson(jsonDecode(preferences.getString("city")));
    PrayerDay prayerDay = PrayerDay(city, dateComponents);
    return prayerDay;
  }

  static Future<PrayerDay> setTodayPrayerDay() async {
    var day = await getPrayerDay();
    todayPrayerDay = day;
    return day;
  }

  static Future<PrayerDay> setNextPrayerDay() async {
    var day = await getPrayerDay(countDay: 1);
    nextPrayerDay = day;
    return day;
  }

  PrayerTimes get prayerTimes => _prayerTimes;

  set prayerTimes(PrayerTimes value) {
    _prayerTimes = value;
  }

  String get date =>
      "${this.prayerTimes.dateComponents.day}.${this.prayerTimes.dateComponents.month}.${this.prayerTimes.dateComponents.year}";
}
