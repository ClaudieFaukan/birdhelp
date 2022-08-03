import 'package:birdhelp/home_page.dart';
import 'package:birdhelp/setting.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'acceuil_page.dart';
import 'camera_page.dart';
import 'google_sign_in.dart';

List<Widget> pages = const [MyAccountPage(), AcceuilPage(), SettingPage(),CameraPage(),];

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Page mon compte connexion succesfull"),
                  Text("${user}"),
                  _signOut(context),
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
        TabItem(icon: Icons.camera_alt_outlined)
      ],
      initialActiveIndex: 0,
      onTap: (int i) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => pages[i]),
      ),
    );
  }

  _signOut(context) {
    return Column(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(50),
          ),
          icon: Icon(Icons.logout),
          label: Text(
            'Deconnection',
            style: TextStyle(fontSize: 24),
          ),
          onPressed: () async {

              FirebaseAuth.instance.signOut();
              try{
                await GoogleSignInProvider().logout();
              }catch (e)
            {
              print(e);
            }

            setState(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            });

          },
        )
      ],
    );
  }
}
