import 'dart:io';

import 'package:birdhelp/setting.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'acceuil_page.dart';
import 'my_account_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();

}
List<Widget> pages = const [MyAccountPage(), AcceuilPage(), SettingPage(), CameraPage()];

class _CameraPageState extends State<CameraPage> {

  File? _image ;
  final imagePicker = ImagePicker();

  Future getImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: _image == null ? Text("Pas d'image selectionner") : Image.file(_image!),
                  ),
                 FloatingActionButton(
                   backgroundColor: Colors.orange,
                     child: Icon(Icons.camera_alt_outlined),
                     onPressed: getImage)
                ],
              ),
            ),
          ),
          bottomNavigationBar: _bottomAppBar(context)),
    );
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
      TabItem(icon: Icons.camera_alt_outlined)
    ],
    initialActiveIndex: 3,
    onTap: (int i) => Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => pages[i]),
    ),
  );
}

