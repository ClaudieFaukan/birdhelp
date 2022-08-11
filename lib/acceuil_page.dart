import 'package:birdhelp/add_fiche_page.dart';
import 'package:birdhelp/google_sign_in.dart';
import 'package:birdhelp/mapp_to_add.dart';
import 'package:birdhelp/models/coordinates.dart';
import 'package:birdhelp/setting.dart';
import 'package:birdhelp/utils.dart';
import 'package:birdhelp/widget.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

import 'my_account_page.dart';



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
                  Text("acceuil"),
                ],
              ),
            ),
          ),
          bottomNavigationBar: CustomWidgets.bottomAppBar(context)),
    );
  }

}
