import 'dart:io';
import 'package:birdhelp/add_animal_on_map.dart';
import 'package:birdhelp/models/categories.dart';
import 'package:birdhelp/models/coordinates.dart';
import 'package:birdhelp/models/fiche.dart';
import 'package:birdhelp/models/health_status.dart';
import 'package:birdhelp/models/helper.dart';
import 'package:birdhelp/services/remote_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'acceuil_page.dart';

class AddFichePage extends StatefulWidget {
  const AddFichePage({Key? key}) : super(key: key);

  @override
  _AddFichePageState createState() => _AddFichePageState();
}

class _AddFichePageState extends State<AddFichePage> {
  final user = FirebaseAuth.instance.currentUser;
  Helper helper = Helper(id: 0, firstName: "", lastName: "", email: "");

  Categories _selectedCategorie = Categories(id: 0, name: "Categorie Animal");
  HealthStatus _selectedStatus = HealthStatus(id: 0, status: "Etat de Santé");
  List<Categories>? categories = [];
  List<HealthStatus>? status = [];
  bool isLoaded = false;
  Coordinate coordinate = Coordinate(id: 0, longitude: 0.0, latitude: 0.0);
  Fiche fiche = Fiche(
      animal: 0,
      geographicCoordinate: [0.0],
      date: DateTime.now(),
      healthstatus: 0,
      description: "",
      category: 0,
      color: "");

  List<DropdownMenuItem<Categories>> categorieItem = [];

  final colorController = TextEditingController();
  final animalController = TextEditingController();
  final healthController = TextEditingController();
  final imageController = TextEditingController();
  final descriptionController = TextEditingController();



  @override
  void initState() {
    super.initState();
    getCategoriesData();
    getHealthStatus();
    getPreferences();
    helper.email = user?.email;
    helper.firstName = user?.displayName;
    helper.lastName = user?.displayName;

    fiche.helper = helper;
  }

  getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //Coordianate
    if (prefs.containsKey('long') == false &&
        prefs.containsKey('lat') == false) {
      await prefs.setDouble('long', 0.0);
      await prefs.setDouble("lat", 0.0);
    } else {
      coordinate.longitude = prefs.getDouble("long")!;
      coordinate.latitude = prefs.getDouble("lat")!;
      fiche.geographicCoordinate = [coordinate.longitude, coordinate.latitude];
    }

    //couleur
    if (prefs.containsKey("color") == false) {
      await prefs.setString("color", "");
    } else {
      colorController.text = prefs.getString("color")!;
    }

    //photo
    if (prefs.containsKey("image") == false) {
      await prefs.setString("image", "");
    } else {
      _image = File(prefs.getString("image")!);
    }
    //description
    if (prefs.containsKey("description") == false) {
      await prefs.setString("description", "");
    } else {
      descriptionController.text = prefs.getString("description")!;
    }
  }

  File? _image;
  final imagePicker = ImagePicker();

  Future pickCamera() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera,maxWidth: 512,maxHeight: 512,imageQuality: 75);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("image", image!.path.toString());
    setState(() {
      _image = File(image!.path);
    });
  }

  Future pickGallery() async {
    try {
      final _image = await imagePicker.pickImage(source: ImageSource.gallery,maxWidth: 512,maxHeight: 512,imageQuality: 75);
      if (_image == null) return;

      final imageTemporary = File(_image.path);
      setState(() => this._image = imageTemporary);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("image", _image!.path.toString());
    } on PlatformException catch (e) {
      print('failed to pick image $e');
    }
  }

  getCategoriesData() async {
    categories = await RemoteService().getCategories();
    if (categories != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getHealthStatus() async {
    status = await RemoteService().getStatus();
    if (status != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    categorieItem = categories!.map((item) {
      return DropdownMenuItem<Categories>(child: Text(item.name), value: item);
    }).toList();

    var statusItem = status!.map((e) {
      return DropdownMenuItem<HealthStatus>(child: Text(e.status), value: e);
    }).toList();

    SharedPreferences prefs;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AcceuilPage(),
                    ),
                  );
                },
                icon: Icon(Icons.home))
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(24),
            child: Visibility(
              visible: isLoaded,
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
              child: Column(children: [
                _header(context),
                _label("Ou l'animal se situe ?"),
                Text(fiche.geographicCoordinate.toString()),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TapToAddPage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.pin_drop),
                  label: Text("coordonnée de l'animal"),
                ),
                _label("Categorie Animal"),
                DropdownButton<Categories>(
                  value: _selectedCategorie.id == 0 ? null : _selectedCategorie,
                  isExpanded: true,
                  hint: Text("Categorie Animal"),
                  items: categorieItem,
                  onChanged: (valu) => setState(() {
                    _selectedCategorie = valu!;
                    fiche.animal = _selectedCategorie.id;
                  }),
                ),
                _label("Etat de santé"),
                DropdownButton<HealthStatus>(
                  value: _selectedStatus.id == 0 ? null : _selectedStatus,
                  isExpanded: true,
                  hint: Text("Etat de sante"),
                  items: statusItem,
                  onChanged: (valu) => setState(() {
                    _selectedStatus = valu!;
                    fiche.healthstatus = valu.id!;
                  }),
                ),
                _label("Couleur de l'animal"),
                TextFormField(
                  controller: colorController,
                  onChanged: (value) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString("color", value);
                    fiche.color = prefs.getString("color");
                  },
                  decoration: InputDecoration(
                    hintText: "Couleur de l'animal",
                    fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                  ),
                ),
                _label("Cliché de l'animal"),
                Center(
                  child: _image == null
                      ? Text("Pas d'image selectionner")
                      : Image.file(_image!),
                ),
                FloatingActionButton(
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.camera_alt_outlined),
                    onPressed: pickCamera),
                ElevatedButton.icon(
                  icon: Icon(Icons.image),
                  label: Text("gallery"),
                  onPressed: pickGallery,
                ),
                _label("Description de la situation"),
                TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  minLines: 1,
                  maxLines: 5,
                  onChanged: (value) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString("description", value);
                    fiche.description = value;
                  },
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    //verifier si tout les element sont present
                    //on envoi tout à une methode externe qui fera le taff
                    //On redirige vers un success ou Non

                    //Si image n'est pas vide alors on ajoute l'image dans la fiche
                    //Sinon image par defaut
                    if(_image!.path != ""){
                      Reference ref = FirebaseStorage.instance.ref().child("animals/${user?.uid}${DateTime.now().microsecondsSinceEpoch.toString()}.jpg");
                      await ref.putFile(_image!);
                      await ref.getDownloadURL().then((value) =>
                      fiche.photo = value
                      );
                    }else{
                      fiche.photo = "https://cdn.dribbble.com/users/1247449/screenshots/3984840/media/dd1c0193e614422d6c9655482fe4a999.png";
                    }
                    RemoteService().postFiche(fiche, context);
                  },
                  icon: Icon(Icons.monitor_heart),
                  label: Text("Je signale"),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  _header(context) {
    return Container(
      child: Text("Signaler un animal en difficulté",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
    );
  }

  _label(string) {
    return Text(
      string,
      style: TextStyle(fontSize: 15),
    );
  }
}
