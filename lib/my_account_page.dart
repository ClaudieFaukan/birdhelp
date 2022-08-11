import 'package:birdhelp/home_page.dart';
import 'package:birdhelp/add_animal_on_map.dart';
import 'package:birdhelp/setting.dart';
import 'package:birdhelp/widget.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'acceuil_page.dart';
import 'google_sign_in.dart';


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
          bottomNavigationBar: CustomWidgets.bottomAppBar(context)),
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
