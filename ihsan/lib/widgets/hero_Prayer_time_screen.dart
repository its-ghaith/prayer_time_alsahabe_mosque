import 'package:Ihsan/screens/city_chose.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant.dart';

class HeroPrayerTimeScreen extends StatefulWidget {
  @override
  _HeroPrayerTimeScreenState createState() => _HeroPrayerTimeScreenState();
}

class _HeroPrayerTimeScreenState extends State<HeroPrayerTimeScreen> {

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        padding: EdgeInsets.only(
          left: 30,
          top: 40,
          right: 20,
        ),
        height: MediaQuery.of(context).size.height * .45,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF100D64),
              Color(0xFF3383CD),
            ],
          ),
          image: DecorationImage(
            image: AssetImage("assets/images/decoration.png"),
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                child: SvgPicture.asset("assets/icons/menu.svg"),
                onTap: () async  {
                  SharedPreferences pre = await SharedPreferences.getInstance();
                  pre.setBool("isCitySetted", false);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return CityChose();
                    },
                  ));
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "إِنَّ ٱلصَّلَوٰةَ كَانَتْ عَلَى ٱلْمُؤْمِنِينَ كِتَـٰبًا مَّوْقُوتًا",
                    style: kHeadingTextStyle.copyWith(
                        color: Colors.white,
                        fontFamily: "Uthman",
                        fontSize: 20),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: SvgPicture.asset(
                    "assets/images/islam.svg",
                    width: 230,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
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
