import 'dart:io';
import 'package:birdhelp/mapp_to_add.dart';
import 'package:birdhelp/models/categories.dart';
import 'package:birdhelp/models/health_status.dart';
import 'package:birdhelp/services/remote_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddFichePage extends StatefulWidget {
  const AddFichePage({Key? key}) : super(key: key);

  @override
  _AddFichePageState createState() => _AddFichePageState();
}

class _AddFichePageState extends State<AddFichePage> {
  Categories _selectedCategorie = Categories(id: 0, name: "Categorie Animal");
  HealthStatus _selectedStatus = HealthStatus(id: 0, status: "Etat de Santé");
  List<Categories>? categories = [];
  List<HealthStatus>? status = [];
  bool categoriesIsLoaded = false;

  @override
  void initState() {
    super.initState();
    getCategoriesData();
    getHealthStatus();

  }
  File? _image ;
  final imagePicker = ImagePicker();

  Future pickCamera() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image!.path);
    });
  }

  Future pickGallery() async {
    try {
      final _image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (_image == null) return;

      final imageTemporary = File(_image.path);
      setState(() => this._image = imageTemporary);
    }on PlatformException catch (e){
      print('failed to pick image $e');
    }
  }

  getCategoriesData() async {
    categories = await RemoteService().getCategories();
    if (categories != null) {
      setState(() {
        categoriesIsLoaded = true;
      });
    }
  }

  getHealthStatus() async {
    status = await RemoteService().getStatus();
    if(status != null){
      setState(() {
        categoriesIsLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    var categoriesItem = categories?.map((item){
      return DropdownMenuItem<Categories>(child: Text(item.name),value: item);
    }).toList();

    var statusItem = status?.map((e){
      return DropdownMenuItem<HealthStatus>(child: Text(e.status),value: e);
    }).toList();


    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
        child:Container(
          margin: EdgeInsets.all(24),
          child: Visibility(
            visible: categoriesIsLoaded,
            child: Column(
              children:[
                _header(context),
                _label("Categorie Animal"),
                DropdownButton<Categories>(
                  isExpanded: true,
                  hint: Text("Categorie Animal"),
                  value: _selectedCategorie,
                  items: categoriesItem,
                  onChanged: (valu)=> setState(() => _selectedCategorie = valu!),
                ),
                _label("Etat de santé"),
                DropdownButton<HealthStatus>(
                  isExpanded: true,
                  hint: Text("Etat de sante"),
                  value: _selectedStatus,
                  items: statusItem,
                  onChanged: (valu)=> setState(() => _selectedStatus = valu!),
                ),
                _label("Description de l'animal"),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Couleur de l'animal",
                    fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                  ),
                ),
                Center(
                  child: _image == null ? Text("Pas d'image selectionner") : Image.file(_image!),
                ),
                FloatingActionButton(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.camera_alt_outlined),
                    onPressed: pickCamera),
                ElevatedButton.icon(icon: Icon(Icons.image),label: Text("gallery"),onPressed: pickGallery,),
                _label("Ou l'animal se situe ?"),
                ElevatedButton.icon(onPressed: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TapToAddPage()));
                }, icon: Icon(Icons.pin_drop), label: Text("coordonnée de l'animal")),

                ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.monitor_heart), label: Text("Je signale")),
              ]
              ),
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
      ),
    );
  }

  _header(context) {
    return Container(
      child:
        Text("Signaler un animal en difficulté",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    );
  }

  _label(string) {
    return Text(string,style: TextStyle(fontSize: 15),);
  }
}
