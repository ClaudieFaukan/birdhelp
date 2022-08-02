import 'package:birdhelp/acceuil_page.dart';
import 'package:birdhelp/google_sign_in.dart';
import 'package:birdhelp/main.dart';
import 'package:birdhelp/signup_page.dart';
import 'package:birdhelp/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'forgot_password_page.dart';
import 'widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
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
        ),
      ),
    );
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
          controller: emailController,
          textInputAction: TextInputAction.done,
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
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: signIn,
          child: const Text(
            "Se connecter",
            style: TextStyle(fontSize: 20),
          ),
          style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 16)),
        ),
        _loginInfo(context),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          child: Text(
            'Mot de passe oublié?',
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Theme.of(context).colorScheme.background,
                fontSize: 20),
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
          ),
        ),
        _loginInfo(context),
        const SizedBox(
          height: 10,
        ),
        Text(
          "Ou connecter vous avec ",
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  _loginInfo(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Pas encore de compte ?"),
        TextButton(
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
        )
      ],
    );
  }

  _loginByTiers(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomWidgets.socialButtonCircle(
            facebookColor, FontAwesomeIcons.facebookF, iconColor: Colors.white,
            onTap: () {
          Fluttertoast.showToast(msg: 'I am circle facebook');
        }),
        CustomWidgets.socialButtonCircle(googleColor, FontAwesomeIcons.google,
            iconColor: Colors.white, onTap: () async {
          final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
          await provider.googleLogin();
          navigatorKey.currentState!.popUntil((route) => route.isFirst);
        }),
        CustomWidgets.socialButtonCircle(twitterColor, FontAwesomeIcons.twitter,
            iconColor: Colors.white, onTap: () {
          Fluttertoast.showToast(msg: 'I am circle whatsapp');
        }),
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
