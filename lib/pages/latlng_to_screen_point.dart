import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import '../widgets/drawer.dart';

class LatLngScreenPointTestPage extends StatefulWidget {
  static const String route = 'latlng_screen_point_test_page';

  const LatLngScreenPointTestPage({Key? key}) : super(key: key);

  @override
  State createState() {
    return _LatLngScreenPointTestPageState();
  }
}

class _LatLngScreenPointTestPageState extends State<LatLngScreenPointTestPage> {
  late final MapController mapController;
  late final StreamSubscription<MapEvent> subscription;

  CustomPoint textPos = const CustomPoint(10.0, 10.0);

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    subscription = mapController.mapEventStream.listen(onMapEvent);
  }

  @override
  void dispose() {
    subscription.cancel();

    super.dispose();
  }

  void onMapEvent(MapEvent mapEvent) {
    if (mapEvent is! MapEventMove && mapEvent is! MapEventRotate) {
      // do not flood console with move and rotate events
      debugPrint(mapEvent.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('LatLng To Screen Point')),
        drawer: buildDrawer(context, LatLngScreenPointTestPage.route),
        body: Stack(children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                onTap: (tapPos, latLng) {
                  final pt1 = mapController.latLngToScreenPoint(latLng);
                  textPos = CustomPoint(pt1!.x, pt1.y);
                  setState(() {});
                },
                center: LatLng(51.5, -0.09),
                zoom: 11,
                rotation: 0,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
              ],
            ),
          ),
          Positioned(
              left: textPos.x.toDouble(),
              top: textPos.y.toDouble(),
              width: 20,
              height: 20,
              child: const FlutterLogo())
        ]));
  }
}
