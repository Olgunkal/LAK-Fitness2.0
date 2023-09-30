import 'package:flutter/material.dart';
import 'package:lak_fitness/props/trainingplan_props.dart';
import 'package:lak_fitness/services/database_service.dart';
import 'package:lak_fitness/styles/color.dart';

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
    return Container(
      //Layout
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: purple, width: 2.0))),

      // Listenelemente ausfahrbar
      child: ExpansionTile(
        title:
            Text(exercise.name, style: Theme.of(context).textTheme.titleSmall),
        trailing: IconButton(
          onPressed: () => addExercise(context),
          icon: const Icon(Icons.add_circle_outline_sharp),
        ),
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.info)),
        iconColor: purple,
        children: [
          ListTile(
            title: Text(exercise.description),
          )
        ],
      ),
    );
  }
}
