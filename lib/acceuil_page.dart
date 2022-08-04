import 'package:birdhelp/google_sign_in.dart';
import 'package:birdhelp/setting.dart';
import 'package:birdhelp/utils.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

import 'camera_page.dart';
import 'map_to_add.dart';
import 'my_account_page.dart';

List<Widget> pages = const [MyAccountPage(), AcceuilPage(), SettingPage(),CameraPage(),TapToAddPage()];

class AcceuilPage extends StatelessWidget {
  const AcceuilPage({Key? key}) : super(key: key);

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
                  Text("Page Acceuil connexion succesfull"),
                  Text("${user}"),
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
      initialActiveIndex: 1,
      onTap: (int i) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => pages[i]),
      ),
    );
  }
}
