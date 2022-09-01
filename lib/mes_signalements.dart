import 'package:birdhelp/services/remote_service.dart';
import 'package:birdhelp/update_fiche.dart';
import 'package:birdhelp/utils.dart';
import 'package:birdhelp/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'models/fiche_retour.dart';

class MesSignalements extends StatefulWidget {
  const MesSignalements({Key? key}) : super(key: key);

  @override
  _MesSignalementsState createState() => _MesSignalementsState();
}

class _MesSignalementsState extends State<MesSignalements> {

  List<FichesRetour> fichesRetour = [];
  bool isLoaded = false;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    getAllFichesUser(user.email!);
    super.initState();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Mes signalements"),
                ficheItem(),
              ],
            ),
          ),
          bottomNavigationBar: CustomWidgets.bottomAppBar(context)),
    );
  }


  Widget ficheItem(){

    return Visibility(
      visible: isLoaded,
      replacement: Center(
        child: CircularProgressIndicator(),
      ),
      child: ListView.separated(
        controller: ScrollController(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final item = fichesRetour[index];
          return buildListTile(item);
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: fichesRetour.length,
      ),
    );
  }


  Widget buildListTile(FichesRetour item) {
    return Slidable(

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
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context)=> _updateFiche(item),
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

  _updateFiche(FichesRetour item){
    Navigator.push( context, MaterialPageRoute( builder: (context) => UpdateFiche(fiche: item)));
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


}
