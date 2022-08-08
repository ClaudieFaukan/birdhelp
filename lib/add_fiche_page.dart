import 'package:birdhelp/models/categories.dart';
import 'package:birdhelp/services/remote_service.dart';
import 'package:flutter/material.dart';

class AddFichePage extends StatefulWidget {
  const AddFichePage({Key? key}) : super(key: key);

  @override
  _AddFichePageState createState() => _AddFichePageState();
}

class _AddFichePageState extends State<AddFichePage> {
  List<Categories>? categories;
  bool categoriesIsLoaded = false;

  @override
  void initState() {
    super.initState();
    getCategoriesData();
  }

  getCategoriesData() async {
    categories = await RemoteService().getCategories();
    if (categories != null) {
      setState(() {
        categoriesIsLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(24),
          child: Visibility(
            visible: categoriesIsLoaded,
            child: ListView.builder(
              itemCount: categories?.length,
              itemBuilder: (context, index) {
                return Container(child: Text(categories![index].name));
              },
            ),
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }

  _header(context) {
    return Column(
      children: [
        Text("Signaler un animal en difficulté",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        Text("Quelques infos et c'est bon")
      ],
    );
  }
  _dropDownCategories(context){

    return new DropdownButton<String>(
      hint: Text('Sélectionnez une categorie Animal'),
      items: categories?.map((value) => {
        return new DropdownMenuItem<String>(
          value: value['id'].toString(),
          child: new Text(value['name']),
        );
      }).toList(),
      onChanged: (_) {},
    )
  }
}
