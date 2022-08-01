import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'widget.dart';
import 'package:fluttertoast/fluttertoast.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        margin: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _header(context),
            _inputFields(context),
            _loginByTiers(context),
          ],
        ),
      ),
    ));
  }

  _header(context) {
    return Column(
      children: [

        const Text(
          "Se connecter",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Image.asset("images/login/hello.gif"),
     ],
    );
  }

  _inputFields(context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Adresse mail',
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
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
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          //TODO
          onPressed: () {},
          child: const Text(
            "Se connecter",
            style: TextStyle(fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              padding: const EdgeInsets.symmetric(
                  vertical: 16
              )
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Text("Ou connecter vous avec ",style: TextStyle(fontStyle: FontStyle.italic),),
      ],
    );
  }
  _loginByTiers(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomWidgets.socialButtonCircle(
              facebookColor, FontAwesomeIcons.facebookF,
              iconColor: Colors.white, onTap: () {
            Fluttertoast.showToast(msg: 'I am circle facebook');
          }),
          CustomWidgets.socialButtonCircle(
              googleColor, FontAwesomeIcons.google,
              iconColor: Colors.white, onTap: () {
            Fluttertoast.showToast(msg: 'I am circle google');
          }),
          CustomWidgets.socialButtonCircle(
              twitterColor, FontAwesomeIcons.twitter,
              iconColor: Colors.white, onTap: () {
            Fluttertoast.showToast(msg: 'I am circle whatsapp');
          }),
        ],
    );
  }
}
