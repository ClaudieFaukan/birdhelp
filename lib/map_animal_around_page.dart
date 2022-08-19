import 'dart:io';
import 'package:birdhelp/models/fiche_retour.dart';
import 'package:birdhelp/services/remote_service.dart';
import 'package:birdhelp/widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:birdhelp/models/coordinates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

class MapAnimalAround extends StatefulWidget {
  const MapAnimalAround({Key? key}) : super(key: key);

  @override
  _MapAnimalAroundState createState() => _MapAnimalAroundState();
}

class _MapAnimalAroundState extends State<MapAnimalAround> {
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
    getAllFichesRetour();
    getAllCoordinate();
    getCurrentLocation();
  }

  getCurrentLocation() async {
    final Location location = Location();
    LocationData _locationData = await location.getLocation();
    setState(() {
      lat = _locationData.latitude!;
      long = _locationData.longitude!;
      addmarkerOnActualPosition(markers, LatLng(lat,long));
      isLoaded = true;
    });
  }

  getAllCoordinate() async {
     coordinates = (await RemoteService().getAllCoordinates())!;
    for (var coord in coordinates) {
      double lati = coord.latitude;
      double longi = coord.longitude;
      LatLng latLng = LatLng(lati, longi);
      setState(() {
        tappedPoints.add(latLng);
      });
    }
  }
  getAllFichesRetour()async{
    fichesRetour = (await RemoteService().getAllFichesRetour())!;
  }

  addmarkerOnActualPosition(List<Marker> list, LatLng latlng){
    var marker = Marker(
      point: latlng,
      builder: (ctx) => Container(
        child: IconButton(
          icon: const Icon(
            Icons.circle,
            color: Colors.blue,
            size: 20,
          ), onPressed: () {  },
        ),
      ),
    );

    list.add(marker);
  }

  @override
  Widget build(BuildContext context) {

    tappedPoints.forEach((element) {
      var marker = Marker(
        point: LatLng(element.latitude, element.longitude),
        builder: (ctx) => Container(
          child: IconButton(
            onPressed: () {
              fichesRetour.forEach((item) {
                if(item.coordinates?.latitude == element.latitude && item.coordinates?.longitude == element.longitude){
                  _showBottomSheet(context, item);
                }
              });
            },
            icon: const Icon(
              Icons.pin_drop,
              color: Colors.red,
              size: 40,
            ),
          ),
        ),
      );
      setState(() {
        markers.add(marker);
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Localiser les animaux proches"),
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
                    MarkerLayerOptions(markers: [
                      for (int i = 0; i < markers.length; i++) markers[i]
                    ])
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

  void _handleTap(TapPosition tapPosition, LatLng latlng) {
  }

  void _handleLongPress(TapPosition tapPosition, LatLng latlng) {}

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
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: new Icon(Icons.monitor_heart),
                    title: Text(fiche.healthStatus ?? "Pas d'information" ),
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
                    title: new Text("Helper : ${fiche.helper?.email.toString()}"),
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
