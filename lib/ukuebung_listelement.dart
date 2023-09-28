import 'package:flutter/material.dart';
import 'package:lak_fitness/basis_theme.dart';

// Startseite Listenelement
class UkuebungListenelement extends StatelessWidget {
  //Konstruktor
  final String uebungName;
  const UkuebungListenelement(this.uebungName, {super.key});

  // Funktion Infotext anzeigen
  void zeigeInfotxt() {}

  // Funktion Uebung zu Trainingsplan hinzufuegen
  void fuegeUebunghinzu() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      //Layout
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
          color: black,
          border: Border(bottom: BorderSide(color: lila, width: 2.0))),

      // Listenelemente
      child: ListTile(
        // Infobutton am Anfang des Listenelements
        leading: IconButton(
          onPressed: zeigeInfotxt,
          icon: Icon(Icons.info),
        ),

        //Title Listenelement
        title: Text(
          uebungName,
          style: const TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white),
        ),

        trailing: IconButton(
          onPressed: fuegeUebunghinzu,
          icon: Icon(Icons.add_circle_outline_sharp),
        ),
      ),
    );
  }
}
