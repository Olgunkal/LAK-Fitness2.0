import 'package:flutter/material.dart';
import 'package:lak_fitness/basis_theme.dart';
import 'package:lak_fitness/pages/trainingsplan.dart';
import 'package:lak_fitness/services/database_service.dart';
import 'package:lak_fitness/uebung_definieren.dart';

import 'models/exercise.dart';

// Startseite Listenelement
class UkuebungListenelement extends StatelessWidget {
  //Konstruktor
  final String uebungName;
  final String trainingsplanName;

  const UkuebungListenelement(this.trainingsplanName, this.uebungName,
      {super.key});

  // Funktion Infotext anzeigen

  // Funktion Uebung zu Trainingsplan hinzufuegen
  Future<void> addExercise(BuildContext context) async {
    await DatabaseService().addExercise(
        trainingsplanName, Exercise(name: uebungName, description: ''));

    Navigator.pop(context);

/*
    Navigator.replace(ctx,
        oldRoute: MaterialPageRoute<Widget>(
            builder: (BuildContext context) =>
                Trainingsplan(trainingsplanName: trainingsplanName)),
        newRoute: MaterialPageRoute<Widget>(
            builder: (BuildContext context) =>
                Trainingsplan(trainingsplanName: trainingsplanName)));
                */
  }

  @override
  Widget build(BuildContext context) {
    void zeigeInfotxt() {
      Navigator.push<Widget>(
          context,
          MaterialPageRoute<Widget>(
              builder: (BuildContext context) =>
                  Uebung_definieren(uebungsName: uebungName)));
    }

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
          onPressed: () => addExercise(context),
          icon: Icon(Icons.add_circle_outline_sharp),
        ),
      ),
    );
  }
}
