import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();

}

class _SignUpPageState extends State<SignUpPage>{

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Container(
            margin: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
              children: [
                _header(context),
                _inputFields(context),
                _loginInfo(context),
              ],
            ),
          ),
        ));
  }

  _header(context) {
    return Column(
      children: [
        Text("Créer votre compte",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        Text("Quelques infos et c'est bon")
      ],
    );
  }

  _inputFields(context) {
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Votre pseudo",
              fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
              filled: true,
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: emailController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "Votre email",
              fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
              filled: true,
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              hintText: "Votre mot de passe",
              fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
              filled: true,
              prefixIcon: Icon(Icons.password_outlined),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
            ),
            obscureText: true,
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Confirmer votre mot de passe",
              fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
              filled: true,
              prefixIcon: Icon(Icons.password_outlined),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
            ),
            obscureText: true,
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: signIn,
            child: Text(
              "S'inscrire",
              style: TextStyle(fontSize: 20),
            ),
            style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(
                    vertical: 16
                )
            ),
          ),
        ],
      );
  }

  _loginInfo(context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Déjà un compte ?"),
        TextButton(onPressed: (){}, child: Text("Se connecter"),)
      ],
    );
  }

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }


}
