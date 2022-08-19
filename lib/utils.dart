
import 'package:birdhelp/models/categories.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Utils {

  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text){

    if (text == null) return;

    final snackBar = SnackBar(content: Text(text),backgroundColor: Colors.red);

    messengerKey.currentState!..removeCurrentSnackBar()..showSnackBar(snackBar);

  }

  static animalIcon(String categorie){
    switch(categorie){
      case "Oiseaux":
        return FontAwesomeIcons.crow;
      case "Reptile":
          return FontAwesomeIcons.dragon;
      case "Mouton":
          return FontAwesomeIcons.hippo;
      case "Cheval":
          return FontAwesomeIcons.horse;
      case "Chien":
          return FontAwesomeIcons.dog;
      case "Chat":
          return FontAwesomeIcons.cat;
      case "Autre":
          return FontAwesomeIcons.question;
      default:
        return FontAwesomeIcons.mapPin;
    }
  }
  static iconColor(String status){
    switch(status){
      case "animal blésser" :
        return Colors.amber;
      case "animal érrant":
        return Colors.blue;
      case "animal mal traité":
        return Colors.red;
      case "animal décéder":
        return Colors.black;
      default:
        return Colors.white;
    }
  }
}