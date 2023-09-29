import 'package:flutter/material.dart';
import 'package:lak_fitness/styles/text_box.dart';
import 'basis_theme.dart';

class Uebung_definieren extends StatefulWidget {
  final String uebungsName;

  //Konstruktor
  Uebung_definieren({required this.uebungsName});

  @override
  State<Uebung_definieren> createState() => _Uebung_definierenState();
}

class _Uebung_definierenState extends State<Uebung_definieren> {
  @override
  Widget build(BuildContext context) {
    String beschreibung = "Das ist eine Beschreibung";

    // Hauptbildschirm
    return Scaffold(
        //AppBar
        appBar: AppBar(
          //Inhalt
          title: Text(widget.uebungsName,
              style: Theme.of(context).textTheme.headlineMedium),
        ),

        // Body
        body: Column(
          children: <Widget>[
            Container(
              width: breiteContainer,
              child: Text("Beschreibung"),
            ),

            //Neu Übung name
            Container(width: breiteContainer, child: Text(beschreibung)),

            Container(
              width: breiteContainer,
              child: Text("Katalog"),
            ),

            //DropDown Katalog
            Container(
                width: breiteContainer,
                child: MyTextBox(
                  sectionName: 'Gewicht:',
                  text: "80",
                  unit: 'kg',
                  onPressed: () {}, //() =>
                  // editField<int>(currentuser.uid, 'Gewicht')
                  //     .then((value) async => {
                  //   setState(() => user.weight = value),
                  //   await DatabaseService()
                  //       .updateUserData(weight: user.weight)
                  // }
                )),

            Container(
              width: breiteContainer,
              child: MyTextBox(
                  sectionName: 'Wiederholungen:',
                  text: "2",
                  unit: '',
                  onPressed: () {} //=>
                  // editField<int>(currentuser.uid, 'Gewicht')
                  //     .then((value) async => {
                  //   setState(() => user.weight = value),
                  //   await DatabaseService()
                  //       .updateUserData(weight: user.weight)
                  // }
                  // )
                  ),
            ),

            Container(
                width: breiteContainer,
                child: MyTextBox(
                    sectionName: 'Sätze:', text: '3', unit: '', onPressed: () {}
                    // =>
                    // editField<int>(currentuser.uid, 'Gewicht')
                    //     .then((value) async => {
                    //   setState(() => user.weight = value),
                    //   await DatabaseService()
                    //       .updateUserData(weight: user.weight)
                    // })
                    )),
          ],
        )
        // Eingabe Name Trainingsplan

        );
  }
}
