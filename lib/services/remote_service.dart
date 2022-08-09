import 'package:birdhelp/models/categories.dart';
import 'package:birdhelp/models/health_status.dart';
import 'package:http/http.dart' as http;

class RemoteService {
  
  var client = http.Client();
  
  
    Future<List<Categories>?> getCategories() async {
      
    var uri = Uri.parse("https://159a-2a01-cb06-30c-2200-ed04-a696-af2e-7b72.eu.ngrok.io/categories");
    var response = await client.get(uri);
    
      if(response.statusCode == 200){
        
        var json = response.body;
        return categoriesFromJson(json);
      }
    }
  
  Future<List<HealthStatus>?> getStatus() async{
    var url = Uri.parse("https://159a-2a01-cb06-30c-2200-ed04-a696-af2e-7b72.eu.ngrok.io/healthstatus");
    var responseStatus = await client.get(url);

      if(responseStatus.statusCode == 200 ){

        var jsonStatus = responseStatus.body;
        return healthStatusFromJson(jsonStatus);
      }
  }
}