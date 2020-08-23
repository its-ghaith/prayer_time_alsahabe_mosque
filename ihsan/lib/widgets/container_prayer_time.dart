import 'package:flutter/material.dart';

class ContainerPrayerTime extends StatelessWidget {
  String prayerName;
  String prayerIcon;
  String time;
  double margin;

  ContainerPrayerTime({@required String prayerName, @required String prayerIcon,@required String time,bool margin= true}){
    this.prayerIcon=prayerIcon;
    this.prayerName=prayerName;
    this.time=time;
    if (margin){
      this.margin= .038;
    }
    else
      this.margin = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*this.margin),
      child: Column(
        children: [
          Text(
            prayerName,
            style: TextStyle(
                fontWeight: FontWeight.w900, fontSize: 16),
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.065,
            width: MediaQuery.of(context).size.width*0.1,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 3,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage(prayerIcon),
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    scale: .0005
                )),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.02,
          ),
          Text(
            time,
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}