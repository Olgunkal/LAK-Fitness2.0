import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:lak_fitness/basis_theme.dart';
import '../sts_listelement.dart';

class neueUebung extends StatefulWidget {
  //Konstruktor
  const neueUebung({super.key});

  @override
  State<neueUebung> createState() => _neueUebungState();
}

class _neueUebungState extends State<neueUebung> {
  //Temporäre Kataloge
  List<String> kataloge = <String>["Bauch", "Arme", "Rücken"];

  @override
  Widget build(BuildContext context) {
    String nameNeuUebung;
    String beschreibung;

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
                    nameNeuUebung = text;
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
                  items: kataloge,
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
                    beschreibung = text;
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Beschreibung",
                    hintText: "Beschreibung",
                  ),
                )),
          ],
        )
        // Eingabe Name Trainingsplan

        );
  }
}
