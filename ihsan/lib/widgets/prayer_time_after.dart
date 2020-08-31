import 'dart:async';
import 'package:Ihsan/localization/localization_constants.dart';
import 'package:Ihsan/models/PrayerDay.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:Ihsan/helper/local_notifications_helper.dart';

class PrayerTimeAfter extends StatefulWidget {
  @override
  _PrayerTimeAfterState createState() => _PrayerTimeAfterState();
}

class _PrayerTimeAfterState extends State<PrayerTimeAfter> {
  Future<dynamic> futurePreferences;
  Timer timer;

  String formatted = "";

  final notifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);

    PrayerDay.getNextPrayerTime();
    futurePreferences = getPreferencesForNextPrayerTime();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => difference());
  }

  Future onSelectNotification(String payload) {
    print(payload);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void difference() async {
    DateTime now = DateTime.now();
    intl.DateFormat formatter = intl.DateFormat('HH:mm:ss');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    DateTime nextTime = DateTime.parse(preferences.getString("nextPrayerTime"));
    var d = now.difference(nextTime);
    String twoDigits(int n) =>
        n != 0 ? n.toString().padLeft(3, "0") : n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));

    if (DateTime.now().compareTo(nextTime) == 1) {
      String prayerTime = preferences.getString("nextPrayerName").replaceAll("Prayer.", "");

      String languageCode = preferences.getString('language_code');
      String title = "Your prayers are your life";
      String body = "Now is the time for Azan";

      if (languageCode == "ar") {
        title = "صلاتك حياتك";
        body = "حان الآن موعد آذان $prayerTime";
      } else if (languageCode == "de") {
        title = "Deine Gebete sind dein Leben";
        body = "Jetzt ist die Zeit für Gebet $prayerTime";
      }
      showOngoingNotification(notifications, title: title, body: body);
    }

    if (DateTime.now().isAfter(nextTime)) {
      PrayerDay.getNextPrayerTime();
    }

    setState(() {
      formatted = "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds"
          .replaceAll("-", "");
    });
  }

  Future<dynamic> getPreferencesForNextPrayerTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * .04,
          bottom: MediaQuery.of(context).size.height * .04),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * .02,
        bottom: MediaQuery.of(context).size.height * .02,
        left: MediaQuery.of(context).size.width * .1,
        right: MediaQuery.of(context).size.width * .1,
      ),
      height: MediaQuery.of(context).size.height * .26,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 30,
            color: kShadowColor,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FutureBuilder<dynamic>(
                future: futurePreferences,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return Text(
                      "${getTrabskated(context, snapshot.data.getString("nextPrayerName"))} ${getTrabskated(context, "azan after")}:",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  return Text(
                    getTrabskated(context, "please wait ..."),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<dynamic>(
                future: futurePreferences,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      formatted,
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w600,
                      ),
                      textDirection: TextDirection.rtl,
                    );
                  }
                  return Text(
                    getTrabskated(context, "wait ..."),
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
