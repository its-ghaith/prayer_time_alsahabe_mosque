import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shared_preferences/shared_preferences.dart';

class PrayerDay {
  String _date;
  DateTime _fadjr;
  DateTime _shuruk;
  DateTime _duhr;
  DateTime _assr;
  DateTime _maghrib;
  DateTime _ishaa;

  static SharedPreferences preferences;
  static PrayerDay todayPrayerDay;
  static PrayerDay nextPrayerDay;

  PrayerDay(this._date, this._fadjr, this._shuruk, this._duhr, this._assr,
      this._maghrib, this._ishaa);

  Map toJson() => {
        'date': date,
        'fadjr': fadjr,
        'shuruk': shuruk,
        'duhr': duhr,
        'assr': assr,
        'maghrib': maghrib,
        'ishaa': ishaa,
      };

  PrayerDay.fromJson(Map json) {
    _date = json['date'];
    _fadjr = DateTime.parse(json['fadjr']['date']);
    _shuruk = DateTime.parse(json['shuruk']['date']);
    _duhr = DateTime.parse(json['duhr']['date']);
    _assr = DateTime.parse(json['assr']['date']);
    _maghrib = DateTime.parse(json['maghrib']['date']);
    _ishaa = DateTime.parse(json['ishaa']['date']);
  }

  String get date => _date;

  DateTime get fadjr => _fadjr;

  DateTime get shuruk => _shuruk;

  DateTime get duhr => _duhr;

  DateTime get assr => _assr;

  DateTime get maghrib => _maghrib;

  DateTime get ishaa => _ishaa;

  static Map<String, dynamic> getDayName(PrayerDay prayerDay) {
    DateTime day = DateTime.parse(prayerDay.date);
    String dayEn = intl.DateFormat('EEEE').format(day);

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
    preferences = await SharedPreferences.getInstance();
    await setTodayPrayerDay();
    await setNextPrayerDay();


    var arr = [
      todayPrayerDay.fadjr,
      todayPrayerDay.shuruk,
      todayPrayerDay.duhr,
      todayPrayerDay.assr,
      todayPrayerDay.maghrib,
      todayPrayerDay.ishaa,
      nextPrayerDay.fadjr
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
    final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd');
    final String formatted =
        formatter.format(now.add(Duration(days: countDay)));
    var day = await rootBundle
        .loadString(
            'assets/cities/Utx5F8y5kF5cX81AtWEooLY3D3mJUfZ8gLQNgbBs.json')
        .then((value) {
      Map decoded = jsonDecode(value)["Dessau-Roßlau"];
      PrayerDay prayerDay = PrayerDay.fromJson(decoded[formatted]);
      return prayerDay;
    });
    return day;
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


}
