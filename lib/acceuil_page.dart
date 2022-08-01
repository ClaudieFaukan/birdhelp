import 'package:birdhelp/google_sign_in.dart';
import 'package:birdhelp/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AcceuilPage extends StatelessWidget {
  const AcceuilPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return SafeArea(
        child: Column(
      children: [
        Text("Page Acceuil connexion succesfull"),
        _signOut(context)
      ],

    ));
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
            if(GoogleSignInProvider.isGoogleUser){
              GoogleSignIn().disconnect();
              FirebaseAuth.instance.signOut();
            }
            FirebaseAuth.instance.signOut();
            },
        )
      ],
    );
  }
}
