import 'dart:developer';

import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../props/trainingplan_props.dart';
import '../services/database_service.dart';
import 'uebungskatalog.dart';
import '../tp_listelement.dart';

// Startseite
class Trainingsplan extends StatefulWidget {
  final TrainingPlanProps props;

  //Konstruktor
  Trainingsplan({required this.props});

  @override
  State<Trainingsplan> createState() => _TrainingsplanState();
}

class _TrainingsplanState extends State<Trainingsplan> {
  List<Exercise> exercises = [];

  void neuUebungHinzufuegen() {
    Navigator.push<Widget>(
        context,
        MaterialPageRoute<Widget>(
            builder: (BuildContext context) => UebungskatalogUebersicht(
                props: TrainingPlanProps(
                    trainingPlanName: widget.props.trainingPlanName,
                    onNotify: onNotify))));
  }

  void onNotify() {
    log('UPDATING');
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var result =
          await DatabaseService().getExercises(widget.props.trainingPlanName);
      setState(() {
        exercises = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Hauptbildschirm
    return Scaffold(
      //AppBar
      appBar: AppBar(
        //Inhalt
        title: Text(widget.props.trainingPlanName,
            style: Theme.of(context).textTheme.headlineMedium),

        //Button
        actions: [
          IconButton(
            onPressed: neuUebungHinzufuegen,
            icon: const Icon(Icons.add_circle),
            style: Theme.of(context).iconButtonTheme.style,
          )
        ],
      ),

      // Body
      body: ListView.builder(
          itemCount: exercises.length,
          itemBuilder: (context, i) {
            return TpListenelement(
                widget.props.trainingPlanName, exercises[i].name, () {
              setState(() {
                exercises.removeWhere(
                    (element) => element.name == exercises[i].name);
              });
            });
          }),
    );
  }
}
