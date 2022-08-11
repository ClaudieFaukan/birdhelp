import 'dart:convert';
import 'dart:io';

import 'package:birdhelp/models/categories.dart';
import 'package:birdhelp/models/health_status.dart';
import 'package:http/http.dart' as http;

import '../models/fiche.dart';

class RemoteService {
  
  var client = http.Client();
  final apiUrl = "https://e2f1-2a01-cb06-30c-2200-31a3-4af3-9fdd-9e96.eu.ngrok.io";
  
    Future<List<Categories>?> getCategories() async {
      
    var uri = Uri.parse("$apiUrl/categories");
    var response = await client.get(uri);
    
      if(response.statusCode == 200){
        
        var json = response.body;
        return categoriesFromJson(json);
      }
    }
  
  Future<List<HealthStatus>?> getStatus() async{
    var url = Uri.parse("$apiUrl/healthstatus");
    var responseStatus = await client.get(url);

      if(responseStatus.statusCode == 200 ){

        var jsonStatus = responseStatus.body;
        return healthStatusFromJson(jsonStatus);
      }
  }

  Future postFiche(Fiche fiche) async {
    var url = Uri.parse("$apiUrl/fiche");
    var ficheparse = ficheToJson(fiche);
    print(ficheparse);
    var response = await client.post(url, headers: {HttpHeaders.contentTypeHeader: "application/json"}, body: ficheparse);

    if(response.statusCode == 201){
      print("success");
    }
          print(response.body);
  }
}