import 'package:flutter/material.dart';
import 'package:lak_fitness/basis_theme.dart';
import 'package:lak_fitness/props/trainingplan_props.dart';
import 'package:lak_fitness/services/database_service.dart';
import 'package:lak_fitness/uebung_definieren.dart';

import 'models/exercise.dart';

// Startseite Listenelement
class UkuebungListenelement extends StatelessWidget {
  final Exercise exercise;
  final TrainingPlanProps props;

  const UkuebungListenelement(this.props, this.exercise, {super.key});

  // Funktion Infotext anzeigen

  // Funktion Uebung zu Trainingsplan hinzufuegen
  Future<void> addExercise(BuildContext context) async {
    await DatabaseService().addExerciseToPlan(props.trainingPlanName, exercise);

    // await DatabaseService().addExercise(
    //     props.trainingPlanName, Exercise(name: uebungName, description: ''));

    if (props.onNotify != null) {
      props.onNotify!();
    }

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Übung erfolgreich hinzugefügt')));
  }

  @override
  Widget build(BuildContext context) {
    void zeigeInfotxt() {
      Navigator.push<Widget>(
          context,
          MaterialPageRoute<Widget>(
              builder: (BuildContext context) =>
                  Uebung_definieren(uebungsName: exercise.name)));
    }

    return Container(
      //Layout
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
          color: black,
          border: Border(bottom: BorderSide(color: lila, width: 2.0))),

      // Listenelemente
      child: ListTile(
        // Infobutton am Anfang des Listenelements
        leading: IconButton(
          onPressed: zeigeInfotxt,
          icon: const Icon(Icons.info),
        ),

        //Title Listenelement
        title: Text(
          exercise.name,
          style: const TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white),
        ),

        trailing: IconButton(
          onPressed: () => addExercise(context),
          icon: const Icon(Icons.add_circle_outline_sharp),
        ),
      ),
    );
  }
}
