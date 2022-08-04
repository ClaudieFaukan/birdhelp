import 'package:birdhelp/setting.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

import 'acceuil_page.dart';
import 'camera_page.dart';
import 'my_account_page.dart';

class TapToAddPage extends StatefulWidget {
  static const String route = '/tap';

  const TapToAddPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TapToAddPageState();
  }
}
List<Widget> pages = const [MyAccountPage(), AcceuilPage(), SettingPage(),CameraPage(),TapToAddPage()];
class TapToAddPageState extends State<TapToAddPage> {
  List<LatLng> tappedPoints = [];

  @override
  Widget build(BuildContext context) {
    final markers = tappedPoints.map((latlng) {
      return Marker(
        width: 80,
        height: 80,
        point: latlng,
        builder: (ctx) => const FlutterLogo(),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Tap to add pins')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Text('Tap to add pins'),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                    center: LatLng(45.5231, -122.6765),
                    zoom: 13,
                    onTap: _handleTap),
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
      ),
      bottomNavigationBar: _bottomAppBar(context),
    );
    
  }

  void _handleTap(TapPosition tapPosition, LatLng latlng) {
    setState(() {
      tappedPoints.add(latlng);
    });
  }
}

_bottomAppBar(context) {
  return ConvexAppBar(
    backgroundColor: Colors.green,
    style: TabStyle.reactCircle,
    items: [
      TabItem(icon: Icons.person),
      TabItem(icon: Icons.add_circle),
      TabItem(icon: Icons.settings),
      TabItem(icon: Icons.camera_alt_outlined),
      TabItem(icon: Icons.gps_fixed),
    ],
    initialActiveIndex: 4,
    onTap: (int i) => Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => pages[i]),
    ),
  );
}
