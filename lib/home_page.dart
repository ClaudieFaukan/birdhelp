import 'package:birdhelp/login_page.dart';
import 'package:birdhelp/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset('images/welcome/croco.gif'),
          Container(
            child: const Text(
              "Vous sauvez des animaux ",
              style: TextStyle(color: Colors.green, fontSize: 22),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: const Text(
              "Notre service permet de recuillir les données géographique des animaux blésser/décéder ou perdu. Pour faire face aux décès massif des goélands , les autorités compétente recommande de ne pas s'approcher lors d'animaux mort ",
              style: TextStyle(color: Colors.black, fontSize: 10),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const SignUpPage();
                        },
                      ),
                    );
                  },
                  child: Text("S'inscrire"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return const LoginPage();
                      }),
                    );
                  },
                  child: Text("Se connecter"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
