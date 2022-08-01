import 'package:flutter/material.dart';

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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
              children: [
                _header(context),
                _inputFields(context),
                _loginByTiers(context),
              ],
            ),
          ),
        ));
  }

  _header(context){

  }
  _inputFields(context){

  }
  _loginByTiers(context){

  }
}