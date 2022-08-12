import 'dart:io';
import 'package:birdhelp/widget.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:birdhelp/add_fiche_page.dart';
import 'package:birdhelp/models/coordinates.dart';
import 'package:birdhelp/models/fiche.dart';
import 'package:birdhelp/setting.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

import 'acceuil_page.dart';
import 'my_account_page.dart';

class TapToAddPage extends StatefulWidget {
  static const String route = '/tap';

  const TapToAddPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TapToAddPageState();
  }
}

class TapToAddPageState extends State<TapToAddPage> {
  double lat = 0.0;
  double long = 0.0;
  List<LatLng> tappedPoints = [];
  bool isLoaded = false;
  Coordinate coordinate = Coordinate(id: 0, longitude: 0.0, latitude: 0.0);
  

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getPreferences();
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

  getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("long") && prefs.containsKey("lat")){

      LatLng latLng = LatLng(prefs.getDouble("lat")!,prefs.getDouble("long")!);

      tappedPoints.add(latLng);
    }
  }


  @override
  Widget build(BuildContext context) {
    final markers = tappedPoints.map((latlng) {
      return Marker(
        width: 100,
        height: 100,
        point: latlng,
        builder: (ctx) => const Icon(
          Icons.pin_drop,
          color: Colors.red,
          size: 40,
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Localiser l'animal"),
        actions: [
          IconButton(
              onPressed: () async {
                //verifier si la coordinates nest pas vide
                //Sinon on initialise la valeur de current location a la place

                if (coordinate.latitude == 0.0 &&
                    coordinate.latitude == 0.0) {
                  coordinate.latitude = lat;
                  coordinate.longitude = long;
                }
                //ajouter long et lat aux preferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setDouble('long', long);
                await prefs.setDouble("lat", lat);

                //retourner sur le formulaire fiche avec coordonne de coordinates
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) =>
                          AddFichePage(),
                    ),
                    (route) => false);
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Visibility(
          visible: isLoaded,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Text('Cliquer sur la carte puis validé'),
              ),
              Flexible(
                child: FlutterMap(
                  options: MapOptions(
                      center: LatLng(lat, long),
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
    if (tappedPoints.length >= 1) {
      tappedPoints.clear();
    }
    setState(() {
      coordinate = Coordinate(
          id: 0, longitude: latlng.longitude, latitude: latlng.latitude);
      tappedPoints.add(latlng);
    });
  }

  void _handleLongPress(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      tappedPoints.clear();
    });
  }
}


