import 'package:Ihsan/localization/localization_constants.dart';
import 'package:Ihsan/models/PrayerDay.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:Ihsan/constant.dart';
import 'package:Ihsan/widgets/container_prayer_time.dart';

class ContainerPrayerDay extends StatefulWidget {
  @override
  _ContainerPrayerDayState createState() => _ContainerPrayerDayState();
}

class _ContainerPrayerDayState extends State<ContainerPrayerDay> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * .02,
        bottom: MediaQuery.of(context).size.height * .02,
        left: MediaQuery.of(context).size.width * .01,
        right: MediaQuery.of(context).size.width * .01,
      ),
      height: MediaQuery.of(context).size.height * .30,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${getTrabskated(context, PrayerDay.getDayName(PrayerDay.todayPrayerDay))} \n ${PrayerDay.todayPrayerDay.date}",
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: kTitleTextstyle,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ContainerPrayerTime(
                prayerIcon: "assets/images/fajer.png",
                prayerName: getTrabskated(context, "Prayer.fajr"),
                time: intl.DateFormat.Hm()
                    .format(PrayerDay.todayPrayerDay.prayerTimes.fajr),
              ),
              ContainerPrayerTime(
                prayerIcon: "assets/images/aufgang.png",
                prayerName: getTrabskated(context, "Prayer.sunrise"),
                time: intl.DateFormat.Hm()
                    .format(PrayerDay.todayPrayerDay.prayerTimes.sunrise),
              ),
              ContainerPrayerTime(
                prayerIcon: "assets/images/mittag.png",
                prayerName: getTrabskated(context, "Prayer.dhuhr"),
                time: intl.DateFormat.Hm()
                    .format(PrayerDay.todayPrayerDay.prayerTimes.dhuhr),
              ),
              ContainerPrayerTime(
                prayerIcon: "assets/images/aser.png",
                prayerName: getTrabskated(context, "Prayer.asr"),
                time: intl.DateFormat.Hm()
                    .format(PrayerDay.todayPrayerDay.prayerTimes.asr),
              ),
              ContainerPrayerTime(
                prayerIcon: "assets/images/untergang.png",
                prayerName: getTrabskated(context, "Prayer.maghrib"),
                time: intl.DateFormat.Hm()
                    .format(PrayerDay.todayPrayerDay.prayerTimes.maghrib),
              ),
              ContainerPrayerTime(
                prayerIcon: "assets/images/asha.png",
                prayerName: getTrabskated(context, "Prayer.isha"),
                time: intl.DateFormat.Hm()
                    .format(PrayerDay.todayPrayerDay.prayerTimes.isha),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
