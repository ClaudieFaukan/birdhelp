import 'package:birdhelp/home_page.dart';
import 'package:birdhelp/add_animal_on_map.dart';
import 'package:birdhelp/models/animals.dart';
import 'package:birdhelp/models/coordinates.dart';
import 'package:birdhelp/models/fiche_retour.dart';
import 'package:birdhelp/models/helper.dart';
import 'package:birdhelp/services/remote_service.dart';
import 'package:birdhelp/setting.dart';
import 'package:birdhelp/utils.dart';
import 'package:birdhelp/widget.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'acceuil_page.dart';
import 'google_sign_in.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  List<FichesRetour> fichesRetour = [];
  bool isLoaded = false;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    getAllFichesUser(user.email!);
  }

  getAllFichesUser(String email) async {
    var fiches = await RemoteService().getAllFichesByUserMail(email);
    if (fiches != null && fiches.isNotEmpty) {
      fiches.forEach((element) {
        setState(() {
          fichesRetour.add(element);
        });
      });
    }
    setState(() {
      isLoaded = true;
    });
  }

  deleteFicheById(int id) {
    RemoteService().deleteFicheById(id, user.email!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Mes signalements"),
                  Container(
                    child: Visibility(
                      visible: isLoaded,
                      replacement: Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: SingleChildScrollView(
                        child: Container(
                          child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = fichesRetour[index];
                                return buildListTile(item);
                              },
                              separatorBuilder: (context, index) => Divider(),
                              itemCount: fichesRetour.length),
                        ),
                      ),
                    ),
                  ),
                  _signOut(context),
                ],
              ),
            ),
          ),
          bottomNavigationBar: CustomWidgets.bottomAppBar(context)),
    );
  }

  Widget buildListTile(FichesRetour item) {
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),

      // The start action pane is the one at the left or the top side.
      startActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),

        // All actions are defined in the children parameter.
        children: [
          SlidableAction(
            onPressed: _doNothing,
            backgroundColor: Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.share,
            label: 'Share',
          ),
        ],
      ),

      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        dismissible: DismissiblePane(onDismissed: () {}),
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: _doNothing,
            backgroundColor: Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Modifier',
          ),
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (context) => _alert(item),
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(item.photo ??
              "https://p7.hiclipart.com/preview/965/769/114/pokemon-go-pikachu-squirtle-charmander-pokemon-png.jpg"),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.category!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(item.description!)
          ],
        ),
      ),
    );
  }

  void _alert(item) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "SUPPRESSION DEFINITIVE",
      desc: "En poursuivant vous allez supprimé définivement ce signalement",
      buttons: [
        DialogButton(
          child: Text(
            "Compris",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => _deleteItem(item),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
      ],
    ).show();
  }

  void _deleteItem(item) {
    setState(() {
      deleteFicheById(item.id!);
      fichesRetour.remove(item);
      Utils.showSnackBar("Vous avez suppimé la fiche");
      Navigator.pop(context);
    });
  }

  void _doNothing(BuildContext context) {
    Fluttertoast.showToast(msg: 'Développement en cours');
  }

  _signOut(context) {
    return Column(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(50),
          ),
          icon: Icon(Icons.logout),
          label: Text(
            'Deconnection',
            style: TextStyle(fontSize: 24),
          ),
          onPressed: () async {
            FirebaseAuth.instance.signOut();
            try {
              await GoogleSignInProvider().logout();
            } catch (e) {
              print(e);
            }

            setState(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            });
          },
        )
      ],
    );
  }
}
