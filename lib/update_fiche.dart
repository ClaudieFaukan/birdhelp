import 'dart:io';
import 'package:birdhelp/add_animal_on_map.dart';
import 'package:birdhelp/models/animals.dart';
import 'package:birdhelp/models/categories.dart';
import 'package:birdhelp/models/coordinates.dart';
import 'package:birdhelp/models/fiche.dart';
import 'package:birdhelp/models/fiche_retour.dart';
import 'package:birdhelp/models/health_status.dart';
import 'package:birdhelp/models/helper.dart';
import 'package:birdhelp/services/remote_service.dart';
import 'package:birdhelp/update_fiche_coordinate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'acceuil_page.dart';

class UpdateFiche extends StatefulWidget {
  const UpdateFiche({Key? key, required this.fiche}) : super(key: key);

  final FichesRetour fiche;

  @override
  _UpdateFicheState createState() => _UpdateFicheState();
}

class _UpdateFicheState extends State<UpdateFiche> {
  final user = FirebaseAuth.instance.currentUser;
  Helper helper = Helper(id: 0, firstName: "", lastName: "", email: "");

  Categories _selectedCategorie = Categories(id: 0, name: "Categorie Animal");
  HealthStatus _selectedStatus = HealthStatus(id: 0, status: "Etat de Santé");
  List<Categories>? categories = [];
  List<HealthStatus>? status = [];
  bool isLoaded = false;
  bool categorieLoaded = false;
  bool statusLoaded = false;
  Coordinate coordinate = Coordinate(id: 0, longitude: 0.0, latitude: 0.0);
  //TEST
  Fiche ficheToSend = Fiche(
      animal: 0,
      geographicCoordinate: [0.0],
      date: DateTime.now(),
      healthstatus: 0,
      description: "",
      category: 0,
      color: "");

  bool imageLoad = false;
  var preferences;
  //END TEST

  List<DropdownMenuItem<Categories>> categorieItem = [];

  final colorController = TextEditingController();
  final animalController = TextEditingController();
  final healthController = TextEditingController();
  final imageController = TextEditingController();
  final descriptionController = TextEditingController();
  final coordinateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getPreferences();
    getCategoriesData();
    getHealthStatus();
    setState(() {
      ficheToSend.helper = widget.fiche.helper!;
      ficheToSend.id = widget.fiche.id;
      _selectedCategorie.name = widget.fiche.category!;
    });
  }

  getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //Coordinate
    if (prefs.containsKey("update") == false) {
      await prefs.setBool("update", true);
    }
    //on initialise les valeurs par defaut de preference a celle de la fiche
    if (prefs.containsKey('long') == false &&
        prefs.containsKey('lat') == false) {
      await prefs.setDouble('long', widget.fiche.coordinates!.longitude);
      await prefs.setDouble("lat", widget.fiche.coordinates!.latitude);
      coordinate.longitude = widget.fiche.coordinates!.longitude;
      coordinate.latitude = widget.fiche.coordinates!.latitude;
    } else {
      //si les preference on changer alors

      coordinate.longitude = prefs.getDouble("long")!;
      coordinate.latitude = prefs.getDouble("lat")!;
      ficheToSend.geographicCoordinate = [
        coordinate.longitude,
        coordinate.latitude
      ];
    }

    //couleur
    if (prefs.containsKey("colorUpdate") == false) {
      setState(() {
        colorController.text = widget.fiche.animal!.color;
      });
      await prefs.setString("colorUpdate", widget.fiche.animal!.color);
    } else {
      setState(() {
        colorController.text = prefs.getString("colorUpdate")!;
      });
    }

    //photo
    if (prefs.containsKey("image") == false) {
      await prefs.setString("image", "");
    } else {
      _image = File(prefs.getString("image")!);
    }
    //description
    if (prefs.containsKey("descriptionUpdate") == false) {
      setState(() {
        descriptionController.text = widget.fiche!.description!!;
      });
      await prefs.setString("descriptionUpdate", widget.fiche!.description!);
    } else {
      setState(() {
        descriptionController.text = prefs.getString("descriptionUpdate")!;
      });
    }
    setState(() {
      isLoaded = true;
    });
  }

  File? _image;
  final imagePicker = ImagePicker();

  Future pickCamera() async {
    final image = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() async {
      await prefs.setString("image", image!.path.toString());
      _image = File(image!.path);
      getImage();
    });
  }

  Future pickGallery() async {
    try {
      final _image = await imagePicker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 512,
          maxHeight: 512,
          imageQuality: 75);
      if (_image == null) return;

      final imageTemporary = File(_image.path);
      setState(() => this._image = imageTemporary);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() async {
        await prefs.setString("image", _image!.path.toString());
        getImage();
      });
    } on PlatformException catch (e) {
      print('failed to pick image $e');
    }
  }

  getCategoriesData() async {
    categories = await RemoteService().getCategories();
    categories!.forEach((element) {
      if (element.name == widget.fiche.category) {
        _selectedCategorie = element;
        setState(() {
          categorieLoaded = true;
        });
      }
    });
    if (categories != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getHealthStatus() async {
    status = await RemoteService().getStatus();
    status!.forEach((element) {
      if (element.status == widget.fiche.healthStatus) {
        _selectedStatus = element;
        setState(() {
          statusLoaded = true;
        });
      }
    });
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

    //Wrap in willscope : if user click ancdroid button back reset prefs
    return WillPopScope(
      onWillPop: () async {
        prefs = await SharedPreferences.getInstance();
        prefs.clear();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () async {
                    prefs = await SharedPreferences.getInstance();
                    prefs.clear();
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
                  _label("Ou l'animal se situe (obligatoire)?"),
                  Text(
                    "[${coordinate.longitude},${coordinate.latitude}]",
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              UpdateCoordinateFiche(fiche: widget.fiche),
                        ),
                      );
                    },
                    icon: Icon(Icons.pin_drop),
                    label: Text("coordonnée de l'animal"),
                  ),
                  _label("Categorie Animal (obligatoire)"),
                  Visibility(
                    visible: categorieLoaded,
                    replacement: CircularProgressIndicator(),
                    child: DropdownButton<Categories>(
                      value: _selectedCategorie.id == 0
                          ? null
                          : _selectedCategorie,
                      isExpanded: true,
                      hint: Text("Categorie Animal"),
                      items: categorieItem,
                      onChanged: (valu) => setState(() {
                        _selectedCategorie = valu!;
                        ficheToSend.animal = valu.id;
                      }),
                    ),
                  ),
                  _label("Etat de santé (obligatoire)"),
                  Visibility(
                    visible: statusLoaded,
                    replacement: CircularProgressIndicator(),
                    child: DropdownButton<HealthStatus>(
                      value: _selectedStatus.id == 0 ? null : _selectedStatus,
                      isExpanded: true,
                      hint: Text("Etat de sante"),
                      items: statusItem,
                      onChanged: (valu) => setState(() {
                        _selectedStatus = valu!;
                        ficheToSend.healthstatus = valu.id;
                      }),
                    ),
                  ),
                  _label("Couleur de l'animal (obligatoire)"),
                  TextFormField(
                    controller: colorController,
                    onChanged: (value) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString("colorUpdate", value);
                      setState(() {
                        ficheToSend.color = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Couleur de l'animal",
                      //fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  _label("Cliché de l'animal (conseiller)"),
                  SizedBox(
                    height: 8,
                  ),
                  Center(child: getImage()),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Camera "),
                      FloatingActionButton(
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.camera_alt_outlined),
                          onPressed: pickCamera),
                      Text(" Gallerie "),
                      ElevatedButton.icon(
                        icon: Icon(Icons.image),
                        label: Text("gallerie"),
                        onPressed: pickGallery,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  _label("Description de la situation (obligatoire)"),
                  TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    minLines: 1,
                    maxLines: 5,
                    onChanged: (value) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString("descriptionUpdate", value);
                      ficheToSend.description = value;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      var listeManquante = [];
                      //Verifier tout les champs si vide ou pas
                      //coord
                      if (coordinate.longitude == 0.0 &&
                          coordinate.latitude == 0.0) {
                        listeManquante.add("Coordonnée de l'animal");
                      }
                      //Animal
                      if (widget.fiche.animal == 0) {
                        listeManquante.add("Categorie Animal");
                      }
                      //EtatDesante
                      if (widget.fiche.healthStatus == 0) {
                        listeManquante.add("Etat de santé");
                      }
                      //couleur
                      if (widget.fiche.animal?.color == "") {
                        listeManquante.add("Couleur animal");
                      }
                      //description
                      if (widget.fiche.description == "") {
                        listeManquante.add("Descripiton de la situation");
                      }

                      if (listeManquante.isNotEmpty) {
                        Alert(
                          context: context,
                          type: AlertType.warning,
                          title: "INFORMATIONS MANQUANTE",
                          desc: "${listeManquante.toString()}",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "Compris",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.pop(context),
                              color: Color.fromRGBO(0, 179, 134, 1.0),
                            ),
                          ],
                        ).show();
                        return;
                      } else {
                        //Si image n'est pas vide alors on ajoute l'image dans la fiche
                        //Sinon image par defaut
                        if (_image != null && _image?.path != "") {
                          print(_image.toString());
                          Reference ref = FirebaseStorage.instance.ref().child(
                              "animals/${user?.uid}${DateTime.now().microsecondsSinceEpoch.toString()}.jpg");
                          await ref.putFile(_image!);
                          await ref
                              .getDownloadURL()
                              .then((value) => ficheToSend.photo = value);
                        }
                        //si fichetosend n'est pas modifier alors return pop up
                        bool isempty = ficheToSendIsEmpty();
                        if(isempty){
                          Alert(
                            context: context,
                            type: AlertType.warning,
                            title: "AUCUNE INFORMATION N'A ÉTÉ CHANGER",
                            desc: "${ficheToSend.toJson()}",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Compris",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                color: Color.fromRGBO(0, 179, 134, 1.0),

                              ),
                            ],
                          ).show();
                          return;
                        }
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.clear();
                        //Change pour update fiche

                        RemoteService()
                            .updateFiche(ficheToSend.id!, ficheToSend, context);
                      }
                    },
                    icon: Icon(Icons.monitor_heart),
                    label: Text("Je modifie mon signalement"),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool ficheToSendIsEmpty(){
    if(ficheToSend.animal != 0 || ficheToSend.geographicCoordinate != [0.0]
        || ficheToSend.photo != null || ficheToSend.healthstatus != 0
        || ficheToSend.description != '' || ficheToSend.color != ''){
      return false;
    }
    return true;
  }
  Widget getImage() {
    if (_image?.path == null || _image?.path == "") {
      return Image.network(widget.fiche.photo!);
    }
    return Image.file(_image!);
  }

  _header(context) {
    return Container(
      child: Text("Modifier votre signalement",
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