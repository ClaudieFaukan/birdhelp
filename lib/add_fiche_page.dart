import 'dart:io';
import 'package:birdhelp/mapp_to_add.dart';
import 'package:birdhelp/models/categories.dart';
import 'package:birdhelp/models/coordinates.dart';
import 'package:birdhelp/models/health_status.dart';
import 'package:birdhelp/services/remote_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Coordinate coordinate = Coordinate(id: 0, longitude: 0.0, lattitude: 0.0);

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
      coordinate.lattitude = prefs.getDouble("lat")!;
    }


    //Etat de sante

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
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("image", image!.path.toString());
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
    } on PlatformException catch (e) {
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
    if (status != null) {
      setState(() {
        categoriesIsLoaded = true;
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
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(24),
            child: Visibility(
              visible: categoriesIsLoaded,
              replacement: const Center(bird help
                child: CircularProgressIndicator(),
              ),
              child: Column(children: [
                _header(context),
                _label(
                    "Categorie Animal"),
                DropdownButton<Categories>(
                  value: _selectedCategorie.id == 0 ? null : _selectedCategorie,
                  isExpanded: true,
                  hint: Text("Categorie Animal"),
                  items: categorieItem,
                  onChanged: (valu) => setState(() {
                    _selectedCategorie = valu!;
                  }),
                ),
                _label("Etat de santé"),
                DropdownButton<HealthStatus>(
                  value: _selectedStatus.id == 0 ?null : _selectedStatus,
                  isExpanded: true,
                  hint: Text("Etat de sante"),
                  items: statusItem,
                  onChanged: (valu) => setState(() => _selectedStatus = valu!),
                ),
                _label("Couleur de l'animal"),
                TextFormField(
                  controller: colorController,
                  onChanged: (value) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString("color", value);
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
                _label("Ou l'animal se situe ?"),
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
                Text(
                    "Coordonee : ${coordinate.lattitude.toString()} -  ${coordinate.longitude.toString()} "),
                _label("Description de la situation"),
                _label(
                    "Plus vous donnez d'infos, plus vous facilité la recherche de l'animal"),
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
                  },
                ),
                ElevatedButton.icon(
                  onPressed: () {},
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
