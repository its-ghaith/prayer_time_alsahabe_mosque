import 'dart:convert';
import 'package:Ihsan/models/City.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart' as intl;
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

  static String getDayName(PrayerDay prayerDay) {
    var year = prayerDay._prayerTimes.dateComponents.year;
    var month = prayerDay._prayerTimes.dateComponents.month;
    var day = prayerDay._prayerTimes.dateComponents.day;
    DateTime dateTimeDay = DateTime(year, month, day);
    String dayEn = intl.DateFormat('EEEE').format(dateTimeDay);
    return dayEn;
  }

  static getNextPrayerTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await setTodayPrayerDay();
    await setNextPrayerDay();

    Prayer prayer = todayPrayerDay.prayerTimes.nextPrayer();
    DateTime dateTimePrayer = todayPrayerDay.prayerTimes.timeForPrayer(prayer);

    if (prayer == Prayer.none) {
      preferences.setString("nextPrayerName", Prayer.fajr.toString());
      preferences.setString(
          "nextPrayerTime", nextPrayerDay.prayerTimes.fajr.toIso8601String());
    } else {
      preferences.setString("nextPrayerName", prayer.toString());
      preferences.setString("nextPrayerTime", dateTimePrayer.toIso8601String());
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
