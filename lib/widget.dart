import 'package:birdhelp/add_fiche_page.dart';
import 'package:birdhelp/setting.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'acceuil_page.dart';
import 'mapp_to_add.dart';
import 'my_account_page.dart';

const Color facebookColor = const Color(0xff39579A);
const Color twitterColor = const Color(0xff00ABEA);
const Color instaColor = const Color(0xffBE2289);
const Color whatsappColor = const Color(0xff075E54);
const Color linkedinColor = const Color(0xff0085E0);
const Color githubColor = const Color(0xff202020);
const Color googleColor = const Color(0xffDF4A32);

List<Widget> pages = const [
  MyAccountPage(),
  AcceuilPage(),
  AddFichePage(),
  TapToAddPage()
];

class CustomWidgets {

  static Widget socialButtonRect(title, color, icon, {Function? onTap}) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ],
        ),
      ),
    );
  }

  static Widget socialButtonCircle(color, icon, {iconColor, Function? onTap}) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Icon(
            icon,
            color: iconColor,
          )), //
    );
  }

  static Widget bottomAppBar(context) {

    List<String> contextString = context.toString().split("(");
    int activeIndex;

    switch(contextString[0]){
      case "MyAccountPage":
        activeIndex = 0;
        break;
      case "AcceuilPage":
        activeIndex = 1;
        break;
      case "AddFichePage":
        activeIndex = 2;
        break;
      case "TapToAddPage":
        activeIndex = 3;
        break;
      default:
        activeIndex = 1;
    }
    return ConvexAppBar(
      backgroundColor: Colors.green,
      style: TabStyle.reactCircle,
      items: [
        TabItem(icon: Icons.person),
        TabItem(icon: Icons.home),
        TabItem(icon: Icons.add_circle),
        TabItem(icon: Icons.gps_fixed),
      ],
      initialActiveIndex: activeIndex,
      onTap: (int i) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => pages[i]),
      ),
    );
  }
}