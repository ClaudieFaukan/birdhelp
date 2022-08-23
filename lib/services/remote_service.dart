import 'dart:convert';
import 'dart:io';

import 'package:birdhelp/main.dart';
import 'package:birdhelp/models/categories.dart';
import 'package:birdhelp/models/coordinates.dart';
import 'package:birdhelp/models/fiche_retour.dart';
import 'package:birdhelp/models/health_status.dart';
import 'package:birdhelp/success_add_fiche.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../acceuil_page.dart';
import '../models/fiche.dart';
import '../utils.dart';

class RemoteService {
  var client = http.Client();
  final apiUrl =
      "https://a3bd-2a01-cb06-30c-2200-fcab-751b-29eb-add4.eu.ngrok.io";

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
    }else {
      throw Exception('Unexpected error occured!');
    }
  }

}
