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
  Coordinate coordinate = Coordinate(id: 0, longitude: 0.0, latitude: 0.0);

  @override
  void initState() {
    super.initState();
    getAllAnimals();
    getCurrentLocation();
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
      double lati = coord.latitude.toDouble();
      double longi = coord.longitude.toDouble();
      LatLng latLng = LatLng(longi, lati);
      setState(() {
        tappedPoints.add(latLng);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final markers = tappedPoints.map((latlng) {
      return Marker(
        width: 100,
        height: 100,
        point: latlng,
        builder: (ctx) => Container(
          child: IconButton(
            onPressed: () {
              _showBottomSheet(context);
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
                      center: LatLng(lat, long),
                      zoom: 13,
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

  void _handleTap(TapPosition tapPosition, LatLng latlng) {}

  void _handleLongPress(TapPosition tapPosition, LatLng latlng) {}

  _showBottomSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(

              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
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
