import 'package:birdhelp/home_page.dart';
import 'package:birdhelp/add_animal_on_map.dart';
import 'package:birdhelp/mes_signalements.dart';
import 'package:birdhelp/models/animals.dart';
import 'package:birdhelp/models/coordinates.dart';
import 'package:birdhelp/models/fiche_retour.dart';
import 'package:birdhelp/models/helper.dart';
import 'package:birdhelp/services/remote_service.dart';
import 'package:birdhelp/setting.dart';
import 'package:birdhelp/update_fiche.dart';
import 'package:birdhelp/utils.dart';
import 'package:birdhelp/widget.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'acceuil_page.dart';
import 'google_sign_in.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final user = FirebaseAuth.instance.currentUser!;
  String signalements = "";
  bool signalementsLoaded = false;
  @override
  void initState() {
    getCountSignalement();
    super.initState();
  }

  getCountSignalement() async {
    signalements = await RemoteService().countFiche(user.email!);
    setState((){
      signalementsLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Mon compte",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 24),),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                      visible: signalementsLoaded,
                      replacement: Center(
                        child: Column(
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size.fromHeight(50),
                              ),
                              icon: Icon(Icons.emergency_outlined),
                              label: Text(
                                'Mes signalements ',
                                style: TextStyle(fontSize: 24),
                              ),
                              onPressed: (){},
                            )
                          ],
                        ),
                      ),
                      child: _mesSignalements(context)),
                  SizedBox(
                    height: 10,
                  ),
                  _signOut(context),
                ],
              ),
          ),
          bottomNavigationBar: CustomWidgets.bottomAppBar(context)),
    );
  }

  _mesSignalements(context){
    return Column(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(50),
          ),
          icon: Icon(Icons.emergency_outlined),
          label: Text(
            'Mes signalements ( $signalements )',
            style: TextStyle(fontSize: 24),
          ),
          onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MesSignalements(),
                ),
              );
          },
        )
      ],
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
            try {
              await GoogleSignInProvider().logout();
            } catch (e) {
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
