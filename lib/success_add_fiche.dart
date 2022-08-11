import 'package:birdhelp/acceuil_page.dart';
import 'package:birdhelp/home_page.dart';
import 'package:birdhelp/widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SuccessAddFiche extends StatefulWidget {
  const SuccessAddFiche({Key? key}) : super(key: key);

  @override
  _SuccessAddFicheState createState() => _SuccessAddFicheState();
}

class _SuccessAddFicheState extends State<SuccessAddFiche> {
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
            onTap: () {
              Fluttertoast.showToast(msg: 'I am circle facebook');
            }),
        CustomWidgets.socialButtonCircle(instaColor, FontAwesomeIcons.instagram,
            iconColor: Colors.white, onTap: () async {}),
        CustomWidgets.socialButtonCircle(whatsappColor, FontAwesomeIcons.whatsapp,
            iconColor: Colors.white, onTap: () {
              Fluttertoast.showToast(msg: 'I am circle whatsapp');
            }),
        CustomWidgets.socialButtonCircle(Colors.green, FontAwesomeIcons.message,
            iconColor: Colors.white, onTap: () {
              Fluttertoast.showToast(msg: 'I am circle message');
            }),
      ],
    );
  }
}
