import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:lak_fitness/basis_theme.dart';
import '../props/new_exercise_props.dart';
import '../services/database_service.dart';

class neueUebung extends StatefulWidget {
  final NewExerciseProps props;
  final String catalogName;

  const neueUebung({super.key, required this.props, required this.catalogName});

  @override
  State<neueUebung> createState() => _neueUebungState();
}

class _neueUebungState extends State<neueUebung> {
  List<String> availableCatalogues = <String>["Bauch", "Arme", "Rücken"];

  Future<void> submit(String name, String description) async {
    try {
      var exercise = await DatabaseService()
          .createExercise(name, description, widget.catalogName);
      widget.props.onNotify!(exercise);
    } finally {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = '';
    String description = '';

    // Hauptbildschirm
    return Scaffold(
        //AppBar
        appBar: AppBar(
          //Inhalt
          title: Text('Übung erstellen',
              style: Theme.of(context).textTheme.headlineMedium),
        ),

        // Body
        body: Column(
          children: <Widget>[
            Container(
              width: breiteContainer,
              child: Text("Name der Übung"),
            ),

            //Neu Übung name
            Container(
                width: breiteContainer,
                child: TextField(
                  onChanged: (text) {
                    name = text;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Trainingsplan",
                    hintText: "Übung",
                  ),
                )),

            Container(
              width: breiteContainer,
              child: Text("Katalog"),
            ),

            //DropDown Katalog
            Container(
                width: breiteContainer,
                child: DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSelectedItems: true,
                    disabledItemFn: (String s) => s.startsWith('I'),
                    showSearchBox: true,
                  ),
                  items: availableCatalogues,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow)),
                      labelText: "Katalog",
                    ),
                  ),
                )),

            Container(
              width: breiteContainer,
              child: Text("Beschreibung"),
            ),

            Container(
                width: breiteContainer,
                child: TextField(
                  onChanged: (text) {
                    description = text;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Beschreibung",
                    hintText: "Beschreibung",
                  ),
                )),
            TextButton(
              onPressed: () => submit(name, description),
              child: Text(
                'Übung erstellen',
                style: TextStyle(),
              ),
            ),
          ],
        )
        // Eingabe Name Trainingsplan

        );
  }
}
