import 'package:Ihsan/models/PrayerDay.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:Ihsan/constant.dart';
import 'package:Ihsan/widgets/container_prayer_time.dart';
import 'package:Ihsan/models/PrayerDay.dart';

class ContainerPrayerDay extends StatefulWidget {
  @override
  _ContainerPrayerDayState createState() => _ContainerPrayerDayState();
}

class _ContainerPrayerDayState extends State<ContainerPrayerDay> {

  Future<PrayerDay> futurePrayerDay;

  @override
  initState() {
    super.initState();
    futurePrayerDay = PrayerDay.getPrayerDay();
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
              FutureBuilder<PrayerDay>(
                future: futurePrayerDay,
                builder: (context, snapshot) {
                  if (snapshot.hasData){
                    return Text(
                      "${PrayerDay.getDayName(PrayerDay.todayPrayerDay)["ar"]} \n ${snapshot.data.date.replaceAll("-", ".")}",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: kTitleTextstyle,
                    );
                  }

                  return Text(
                    "",
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: kTitleTextstyle,
                  );
                },
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder<PrayerDay>(
                future: futurePrayerDay,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return ContainerPrayerTime(
                      prayerIcon: "assets/images/asha.png",
                      prayerName: "العشاء",
                      time: intl.DateFormat.Hm().format(snapshot.data.ishaa),
                    );

                  return ContainerPrayerTime(
                    prayerIcon: "assets/images/asha.png",
                    prayerName: "العشاء",
                    time: "",
                  );
                },
              ),
              FutureBuilder<PrayerDay>(
                future: futurePrayerDay,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return ContainerPrayerTime(
                      prayerIcon: "assets/images/untergang.png",
                      prayerName: "المغرب",
                      time: intl.DateFormat.Hm().format(snapshot.data.maghrib),
                    );
                  return ContainerPrayerTime(
                    prayerIcon: "assets/images/untergang.png",
                    prayerName: "المغرب",
                    time: "",
                  );
                },
              ),
              FutureBuilder<PrayerDay>(
                future: futurePrayerDay,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return ContainerPrayerTime(
                      prayerIcon: "assets/images/aser.png",
                      prayerName: "العصر",
                      time: intl.DateFormat.Hm().format(snapshot.data.assr),
                    );
                  return ContainerPrayerTime(
                    prayerIcon: "assets/images/aser.png",
                    prayerName: "العصر",
                    time: "",
                  );
                },
              ),
              FutureBuilder<PrayerDay>(
                future: futurePrayerDay,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return ContainerPrayerTime(
                      prayerIcon: "assets/images/mittag.png",
                      prayerName: "الظهر",
                      time: intl.DateFormat.Hm().format(snapshot.data.duhr),
                    );
                  return ContainerPrayerTime(
                    prayerIcon: "assets/images/mittag.png",
                    prayerName: "الظهر",
                    time: "",
                  );
                },
              ),
              FutureBuilder<PrayerDay>(
                future: futurePrayerDay,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return ContainerPrayerTime(
                      prayerIcon: "assets/images/aufgang.png",
                      prayerName: "الشروق",
                      time: intl.DateFormat.Hm().format(snapshot.data.shuruk),
                    );
                  return ContainerPrayerTime(
                    prayerIcon: "assets/images/aufgang.png",
                    prayerName: "الشروق",
                    time: "",
                  );
                },
              ),
              FutureBuilder<PrayerDay>(
                future: futurePrayerDay,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return ContainerPrayerTime(
                      margin: false,
                      prayerIcon: "assets/images/fajer.png",
                      prayerName: "الفجر",
                      time: intl.DateFormat.Hm().format(snapshot.data.fadjr),
                    );
                  return ContainerPrayerTime(
                    margin: false,
                    prayerIcon: "assets/images/fajer.png",
                    prayerName: "الفجر",
                    time: "",
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
