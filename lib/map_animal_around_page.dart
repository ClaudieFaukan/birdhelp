import 'dart:io';
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

  @override
  void initState() {
    getAllAnimals();
    getCurrentLocation();
    super.initState();
  }

  getCurrentLocation() async {
    final Location location = Location();
    LocationData _locationData = await location.getLocation();
    setState(() {
      lat = _locationData.latitude!;
      long = _locationData.longitude!;
      isLoaded = true;
    });
  }

  getAllAnimals() async {
    List<Coordinate> coordinates = (await RemoteService().getAllCoordinates())!;
    for (var coord in coordinates) {
      double lati = coord.latitude;
      double longi = coord.longitude;
      LatLng latLng = LatLng(lati, longi);
      setState(() {
        tappedPoints.add(latLng);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final markers = tappedPoints.map((thislatlng) {
      return Marker(
        width: 100,
        height: 100,
        point: thislatlng,
        builder: (ctx) => Container(
          child: IconButton(
            onPressed: () {
              _showBottomSheet(context, thislatlng);
            },
            icon: const Icon(
              Icons.pin_drop,
              color: Colors.red,
              size: 40,
            ),
          ),
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Localiser les animaux proches"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Visibility(
          visible: isLoaded,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Text('Cliquer sur l\'animal pour en savoir plus'),
              ),
              Flexible(
                child: FlutterMap(
                  options: MapOptions(
                      center: LatLng(lat,long),
                      zoom: 17,
                      onTap: _handleTap,
                      onLongPress: _handleLongPress),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    ),
                    MarkerLayerOptions(markers: markers)
                  ],
                ),
              ),
            ],
          ),
          replacement: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      bottomNavigationBar: CustomWidgets.bottomAppBar(context),
    );
  }

  void _handleTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      tappedPoints.add(latlng);
    });
  }

  void _handleLongPress(TapPosition tapPosition, LatLng latlng) {}

  _showBottomSheet(context, latlng) {
    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(latlng.toString()),
                  Text("Category Animal"),
                  Text("Fiche partager le date a heure"),
                  ListTile(
                    leading: new Icon(Icons.photo),
                    title: new Text('Voir la photo'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: new Icon(Icons.monitor_heart),
                    title: new Text('Etat de sante'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: new Icon(Icons.description),
                    title: new Text('Description situation'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: new Icon(FontAwesomeIcons.hireAHelper),
                    title: new Text("Helper "),
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
