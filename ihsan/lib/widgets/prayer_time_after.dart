import 'dart:async';
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
    PrayerDay.getNextPrayerTime();
    futurePreferences = getPreferencesForNextPrayerTime();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => difference());

    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
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
      String prayerTime = preferences.getString("nextPrayerName");
      showOngoingNotification(notifications,
          title: "صلاتك حياتك", body: "حان الآن موعد اذان $prayerTime");
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FutureBuilder<dynamic>(
                future: futurePreferences,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return Text(
                      "صلاة ${snapshot.data.getString("nextPrayerName")} بعد:",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                      textDirection: TextDirection.rtl,
                    );
                  return Text(
                    "صلاة null بعد:",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
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
                    "null",
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
