
import 'package:birdhelp/models/fiche_retour.dart';
import 'package:birdhelp/services/remote_service.dart';
import 'package:birdhelp/utils.dart';
import 'package:birdhelp/widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:birdhelp/models/coordinates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

class MapAnimalAround extends StatefulWidget {
  const MapAnimalAround({Key? key}) : super(key: key);

  @override
  _MapAnimalAroundState createState() => _MapAnimalAroundState();
}

class _MapAnimalAroundState extends State<MapAnimalAround> {
  double radiusMeter = 2000;
  String labelRadius = "";
  double lat = 0.0;
  double long = 0.0;
  List<LatLng> tappedPoints = [];
  bool isLoaded = false;
  List<Marker> markers = [];
  List<Coordinate> coordinates = [];
  List<FichesRetour> fichesRetour = [];

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    setState(() {
      labelRadius = radiusMeter.round().toString();
    });
  }

  getCurrentLocation() async {
    final Location location = Location();
    LocationData _locationData = await location.getLocation();
    setState(() {
      lat = _locationData.latitude!;
      long = _locationData.longitude!;
      //on ajoute le marker de position de l'utilisateur
      addmarkerOnActualPosition(markers, LatLng(lat, long));
      //On recherche mes fiches et les positions des animaux a proximité avec le parametre variable radius meter
      getFichesAroundRadius();
    });

  }

  getFichesAroundRadius() async {
    //coordonné de l'utulisateur
    Coordinate currentPosition = new Coordinate(
        id: 0, latitude: lat, longitude: long);
    //fiches retour en fonction du parametre radius meter variable et de la current position de l'utilisateur
    fichesRetour = (await RemoteService()
        .getFicheRetourByRadius(currentPosition, radiusMeter))!;
    for (var coord in fichesRetour!) {
      double lati = coord.coordinates!.latitude;
      double longi = coord.coordinates!.longitude;
      LatLng latLng = LatLng(lati, longi);
      setState(() {
        tappedPoints.add(latLng);
      });
      setState(() {
        isLoaded =true;
      });
    }
  }



  addmarkerOnActualPosition(List<Marker> list, LatLng latlng) {
    //Ajoute le marker de postion actuel de l'user
    var marker = Marker(
      point: latlng,
      builder: (ctx) => Container(
        child: IconButton(
          icon: const Icon(
            Icons.circle,
            color: Colors.blue,
            size: 20,
          ),
          onPressed: () {},
        ),
      ),
    );

    list.add(marker);
  }

  @override
  Widget build(BuildContext context) {

    //Pour chaque point geographique de fiche retour
    tappedPoints.forEach((element) {
      //initialise des markers par defaut
      IconData icon = FontAwesomeIcons.mapPin;
      FichesRetour fiche = FichesRetour();
      Color color = Colors.white;

      //Pour chaque fiche retour
      fichesRetour.forEach((item) {
        //compare si la fiche retour correpond a ce poitn geographique
        if (item.coordinates?.latitude == element.latitude &&
            item.coordinates?.longitude == element.longitude) {
          //On personnalise les markers et on ajoute la fiche retour coorespondant au point geographique
          setState(() {
            icon = Utils.animalIcon(item.category!);
            color = Utils.iconColor(item.healthStatus!);
            fiche = item;
            return;
          });
        }
      });
      //Création du marker physique
      var marker = Marker(
        point: LatLng(element.latitude, element.longitude),
        builder: (ctx) => Container(
          child: IconButton(
            onPressed: () {
              _showBottomSheet(context, fiche);
            },
            icon: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
        ),
      );
      setState(() {
        //on met a jour la page
        markers.add(marker);
      });
    });

    //rayon de recherche
    final circleMarkers = <CircleMarker>[
      CircleMarker(

          point: LatLng(lat, long),
          color: Colors.blue.withOpacity(0.15),
          borderStrokeWidth: 2,
          useRadiusInMeter: true,
          radius: radiusMeter),
    ];


    return Scaffold(
      appBar: AppBar(
        title: const Text("Localiser les animaux proches"),
        actions: [
          IconButton(
              onPressed: () => _showBottomConfiguration(),
              icon: Icon(Icons.build)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Visibility(
          visible: isLoaded,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Text('Cliquer sur l\'animal pour en savoir plus'),
              ),
              Flexible(
                child: FlutterMap(
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    ),
                    CircleLayerOptions(circles: circleMarkers),
                    MarkerLayerOptions(markers: [
                      for (int i = 0; i < markers.length; i++) markers[i]
                    ]),

                  ],
                  options: MapOptions(
                    center: LatLng(lat, long),
                    zoom: 17,
                    onTap: _handleTap,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomWidgets.bottomAppBar(context),
    );
  }

  void _handleTap(TapPosition tapPosition, LatLng latlng) {}

  void _handleLongPress(TapPosition tapPosition, LatLng latlng) {}

  _showBottomConfiguration() {
    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (context,state){
            return Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Paramètre de recherche"),
                  Text("Modifier le rayon de recherche"),
                  Slider(
                    value: radiusMeter,
                    min: 2000,
                    max: 200000,
                    label: labelRadius,
                    onChanged: (double value) {
                    updated(state, value);
                    },
                  ),
                ],
              ),
            );
          });
        });
  }
  Future<void> updated(StateSetter updateState, value) async {
    //mis a jour de l'etat du bottom sheet
    updateState(() {
      radiusMeter = value;
      labelRadius = radiusMeter.round().toString();
    });
    //mis a jour de letat de la carte
    setState(() {
      radiusMeter = value;
      labelRadius = radiusMeter.round().toString();
      getFichesAroundRadius();
    });
  }
  _showBottomSheet(context, FichesRetour fiche) async {
    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(fiche.category!),
                  Text(fiche.date.toString()),
                  ListTile(
                    leading: new Icon(Icons.photo),
                    title: new Text('Voir la photo'),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (builder) {
                            return Container(
                              color: Colors.white,
                              child: Image.network(fiche.photo!),
                            );
                          });
                    },
                  ),
                  ListTile(
                    leading: new Icon(Icons.monitor_heart),
                    title: Text(fiche.healthStatus ?? "Pas d'information"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: new Icon(Icons.description),
                    title: Text(fiche.description ?? "Pas d'information"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: new Icon(FontAwesomeIcons.hireAHelper),
                    title:
                        new Text("Helper : ${fiche.helper?.email.toString()}"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: new Icon(Icons.share),
                    title: new Text('Partager cette fiche'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ));
        });
  }
}
