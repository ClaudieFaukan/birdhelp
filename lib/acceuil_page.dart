import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AcceuilPage extends StatelessWidget {
  const AcceuilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return SafeArea(
        child: Column(
      children: [
        Text("Page Acceuil connexion succesfull"),
        Text(user.email!),
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
          onPressed: ()=> FirebaseAuth.instance.signOut(),
        )
      ],
    );
  }
}
