import 'package:birdhelp/camera_page.dart';
import 'package:birdhelp/map_to_add.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'acceuil_page.dart';
import 'my_account_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

List<Widget> pages = const [MyAccountPage(), AcceuilPage(), SettingPage(), CameraPage(),TapToAddPage()];

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Page Settings"),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _bottomAppBar(context)),
    );
  }

  _bottomAppBar(context) {
    return ConvexAppBar(
      backgroundColor: Colors.green,
      style: TabStyle.reactCircle,
      items: [
        TabItem(icon: Icons.person),
        TabItem(icon: Icons.add_circle),
        TabItem(icon: Icons.settings),
        TabItem(icon: Icons.camera_alt_outlined),
        TabItem(icon: Icons.gps_fixed)
      ],
      initialActiveIndex: 2,
      onTap: (int i) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => pages[i]),
      ),
    );
  }
}
