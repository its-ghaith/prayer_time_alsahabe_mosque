import 'package:Ihsan/models/PrayerDay.dart';
import 'package:Ihsan/widgets/container_Prayer_Day.dart';
import 'package:Ihsan/widgets/hero_Prayer_time_screen.dart';
import 'package:Ihsan/widgets/prayer_time_after.dart';
import 'package:flutter/material.dart';

class PrayerTimeScreen extends StatefulWidget {
  @override
  _PrayerTimeScreenState createState() {
    return _PrayerTimeScreenState();
  }
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  Future<bool> prayer;

  @override
  initState() {
    super.initState();
    prayer = Hallo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          HeroPrayerTimeScreen(),
          FutureBuilder(
              future: prayer,
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return ContainerPrayerDay();
                return CircularProgressIndicator();
              }
          ),
          FutureBuilder(
              future: prayer,
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return PrayerTimeAfter();
                return CircularProgressIndicator();
              }
          )

        ],
      ),
    );
  }

  Future<bool> Hallo() async {
    await PrayerDay.getNextPrayerTime();
    return true;
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
