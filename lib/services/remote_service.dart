import 'package:birdhelp/models/categories.dart';
import 'package:http/http.dart' as http;

class RemoteService {
  Future<List<Categories>?> getCategories() async {
  var client = http.Client();
  
  var uri = Uri.parse("https://1442-2a01-cb06-30c-2200-9d76-df33-a440-9ec.eu.ngrok.io/categories");
  var response = await client.get(uri);
  if(response.statusCode == 200){
    var json = response.body;
    return categoriesFromJson(json);
  }
  }
}