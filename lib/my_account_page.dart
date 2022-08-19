import 'package:birdhelp/home_page.dart';
import 'package:birdhelp/add_animal_on_map.dart';
import 'package:birdhelp/models/fiche_retour.dart';
import 'package:birdhelp/services/remote_service.dart';
import 'package:birdhelp/setting.dart';
import 'package:birdhelp/utils.dart';
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

  List<FichesRetour> fichesRetour = [];

  final user = FirebaseAuth.instance.currentUser!;

  @override void initState() {
    super.initState();
    getAllFichesUser(user.email!);
  }


  Future getAllFichesUser(String email) async {

      var fiches = await RemoteService().getAllFichesByUserMail(email);
      fiches?.forEach((element) {
        fichesRetour.add(element);
      });
  }


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
                  Text("Mes signalements"),
                Container(child: Row(
                  children: [
                    CircleAvatar(child: Image.network(fichesRetour[0].photo!),backgroundColor: Colors.white,),
                    Text(fichesRetour[0].category!),
                    Text(" Date: ${fichesRetour[0].date}"),
                  ],
                ),
            ),
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
