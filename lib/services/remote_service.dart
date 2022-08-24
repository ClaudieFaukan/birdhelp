import 'dart:convert';
import 'dart:io';

import 'package:birdhelp/main.dart';
import 'package:birdhelp/models/categories.dart';
import 'package:birdhelp/models/coordinates.dart';
import 'package:birdhelp/models/fiche_around_radius.dart';
import 'package:birdhelp/models/fiche_retour.dart';
import 'package:birdhelp/models/health_status.dart';
import 'package:birdhelp/success_add_fiche.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../acceuil_page.dart';
import '../models/animals.dart';
import '../models/fiche.dart';
import '../models/helper.dart';
import '../utils.dart';

class RemoteService {
  var client = http.Client();
  //https://api-birdhelp.herokuapp.com/
  final apiUrl =
      "https://api-birdhelp.herokuapp.com";

  Future<List<Categories>?> getCategories() async {
    var uri = Uri.parse("$apiUrl/categories");
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;
      return categoriesFromJson(json);
    }
  }

  Future<List<HealthStatus>?> getStatus() async {
    var url = Uri.parse("$apiUrl/healthstatus");
    var responseStatus = await client.get(url);

    if (responseStatus.statusCode == 200) {
      var jsonStatus = responseStatus.body;
      return healthStatusFromJson(jsonStatus);
    }
  }

  Future postFiche(Fiche fiche, context) async {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
  try{
    var url = Uri.parse("$apiUrl/fiche");
    var ficheparse = ficheToJson(fiche);
    var response = await client.post(url,
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: ficheparse);

    if (response.statusCode == 201) {
      //redirection success
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SuccessAddFiche(),
        ),
      );
    } else {
      //add snackbar error
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AcceuilPage(),
        ),
      );
      Utils.showSnackBar("Une erreur est survenue, la création de la fiche n'a pas aboutie");

    }
  }catch(e){
    Utils.showSnackBar(e.toString());
  }
  }

  Future<List<Coordinate>?> getAllCoordinates() async {
    var url = Uri.parse("$apiUrl/coordinates");
    var response = await client.get(url);

    if (response.statusCode == 200) {
      var jsonStatus = response.body;
      return coordinateFromJson(jsonStatus);
    }else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<FichesRetour>?> getFicheById(int id) async {
    var url = Uri.parse("$apiUrl/fiche/coordinate/$id");
    var response = await client.get(url);
    if (response.statusCode == 200){
      var json = response.body;
      json = "["+json+"]";
      print(json);
      List<FichesRetour>? encode = fichesRetourFromJson(json);
      return encode;
    }else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<FichesRetour>?> getAllFichesRetour() async {
    var url = Uri.parse("$apiUrl/fiches");
    var response = await client.get(url);
    if (response.statusCode == 200){
      var json = response.body;
      List<FichesRetour>? encode = fichesRetourFromJson(json);
      return encode;
    }else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<FichesRetour>> getAllFichesByUserMail(String mail) async {

    var url = Uri.parse("$apiUrl/user/fiches/$mail");
    var response = await client.get(url);

    if (response.statusCode == 200){

      var json = response.body;
      json = json;
      List<FichesRetour> encode = fichesRetourFromJson(json);
      return encode;
    }else if (response.statusCode == 403){
      return [new FichesRetour(id: 0,helper: new Helper(id: 0),animal: new Animals(id: 0, color: ""),healthStatus: "",category: "Pas des signalement pour l'instant",
          date: new DateTime.now(), description: "Continué à regarder autour de vous, un animal à peut être besoin d'être signaler", coordinates: new Coordinate(id: 0, latitude:0.0, longitude:0.0))];
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<FichesRetour>?> getFicheRetourByRadius(Coordinate currentPosition, double radiusMeter) async{
    var ficheRadius = new FicheAroundRadius(coordinates: currentPosition, radius: radiusMeter);
    var json = jsonEncode(ficheRadius.toJson());
    var url = Uri.parse("$apiUrl/coordinates/by_current_position/radius");
    var response = await client.post(url,headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: json);

    if (response.statusCode == 200){

      var json = response.body;
      json = json;
      List<FichesRetour> encode = fichesRetourFromJson(json);

      return encode;
    }else if (response.statusCode == 403){
      List<FichesRetour> encodeBydefaut = [new FichesRetour(id:0,helper: new Helper(id: 0),coordinates: new Coordinate(id: 0, latitude: 0.0 , longitude: 0.0),description: '',photo: '',date: DateTime.now(),category: "",healthStatus: "",animal: new Animals(id: 0, color: ''))];
      return encodeBydefaut;
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<void> deleteFicheById(int id, String email) async{
    var jsonMail = {"email":email};
    var json = jsonEncode(jsonMail);
    var url = Uri.parse("$apiUrl/user/delete/fiche/${id}");
    var response = await client.post(url,headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: json);
    if (response.statusCode == 200){
      return ;
    }else if (response.statusCode == 204){
      print("something wrong");
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }


}
