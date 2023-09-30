import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../props/new_exercise_props.dart';
import '../services/database_service.dart';
import 'package:lak_fitness/styles/color.dart';

class neueUebung extends StatefulWidget {
  final NewExerciseProps props;
  final String catalogName;

  const neueUebung({super.key, required this.props, required this.catalogName});

  @override
  State<neueUebung> createState() => _neueUebungState();
}

class _neueUebungState extends State<neueUebung> {
  // Liste der Kataloge
  List<String> availableCatalogues = <String>[
    'Brust',
    'Beine',
    'Rücken',
    'Arme',
    'Bauch'
  ];

  // Erstellung einer Übung
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
        backgroundColor: background,
        //AppBar
        appBar: AppBar(
          title: Text('Übung erstellen',
              style: Theme.of(context).textTheme.headlineMedium),
          backgroundColor: background,
        ),

        // Body
        body: Column(
          children: <Widget>[
            const SizedBox(
              child: Text("Name der Übung"),
            ),

            // Texfeld für neue Übung
            SizedBox(
                child: TextField(
              onChanged: (text) {
                name = text;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Trainingsplan",
                hintText: "Übung",
              ),
            )),

            const SizedBox(
              child: Text("Katalog"),
            ),

            //DropDown Katalog
            SizedBox(
                child: DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSelectedItems: true,
                disabledItemFn: (String s) => s.startsWith('I'),
                showSearchBox: true,
              ),
              items: availableCatalogues,
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow)),
                  labelText: "Katalog",
                ),
              ),
            )),

            const SizedBox(
              child: Text("Beschreibung"),
            ),

            // Textfeld für Beschreibung
            SizedBox(
                child: TextField(
              onChanged: (text) {
                description = text;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Beschreibung",
                hintText: "Beschreibung",
              ),
            )),
            // Button zum erstellen einer Übung
            TextButton(
              onPressed: () => submit(name, description),
              child: const Text(
                'Übung erstellen',
                style: TextStyle(),
              ),
            ),
          ],
        ));
  }
}
