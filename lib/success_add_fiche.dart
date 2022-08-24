import 'package:birdhelp/acceuil_page.dart';
import 'package:birdhelp/home_page.dart';
import 'package:birdhelp/widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SuccessAddFiche extends StatefulWidget {
  const SuccessAddFiche({Key? key}) : super(key: key);

  @override
  _SuccessAddFicheState createState() => _SuccessAddFicheState();
}

enum SocialMedia {facebook,instagram,whatsapp,mail}

class _SuccessAddFicheState extends State<SuccessAddFiche> {




  @override
  void initState() {
    super.initState();
    _clearPrefrences();
  }

  _clearPrefrences()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(
        appBar:AppBar(title: Text("Signalement effectuer"),automaticallyImplyLeading: false, actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AcceuilPage(),),);
          }, icon: Icon(Icons.home))
        ],),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(24),
            child: Column(children: [
              Text("Nous lançons le signal de secours autour de l'animal", style: TextStyle(fontSize: 20),),
              Image.asset("images/ambulance.gif"),
              Text("Merci beaucoup d'avoir signalé cette animal"),
              SizedBox(
                height: 10,
              ),
              Text("Partager cette informations!",style: TextStyle(fontStyle: FontStyle.italic)),
              SizedBox(
                height: 10,
              ),
              _sharredByTiers(context),
            ]),
          ),
        ),
      ),
    );
  }



  _sharredByTiers(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomWidgets.socialButtonCircle(
            facebookColor, FontAwesomeIcons.facebookF, iconColor: Colors.white,
            onTap: () async {
              Fluttertoast.showToast(msg: 'Développement en cours');
            }),
        CustomWidgets.socialButtonCircle(instaColor, FontAwesomeIcons.instagram,
            iconColor: Colors.white, onTap: () async {
              Fluttertoast.showToast(msg: 'Développement en cours');
            }),
        CustomWidgets.socialButtonCircle(whatsappColor, FontAwesomeIcons.whatsapp,
            iconColor: Colors.white, onTap: (
                ) {
              Fluttertoast.showToast(msg: 'Développement en cours');

            }),
        CustomWidgets.socialButtonCircle(googleColor, FontAwesomeIcons.google,
            iconColor: Colors.white, onTap: () {
              Fluttertoast.showToast(msg: 'Développement en cours');
            }),
      ],
    );
  }
}
