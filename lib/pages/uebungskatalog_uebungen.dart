import 'package:flutter/material.dart';
import '../models/current_exercise_state.dart';
import '../models/exercise.dart';
import '../props/new_exercise_props.dart';
import '../props/trainingplan_props.dart';
import '../services/database_service.dart';
import '../ukuebung_listelement.dart';
import 'neuUebung.dart';

// Startseite
class UebungskatalogUebungen extends StatefulWidget {
  final String uebungskatalogName;
  final TrainingPlanProps props;

  UebungskatalogUebungen(
      {required this.props, required this.uebungskatalogName});

  @override
  State<UebungskatalogUebungen> createState() => _UebungskatalogUebungenState();
}

class _UebungskatalogUebungenState extends State<UebungskatalogUebungen> {
  // Temporäre Schnittstelle
  List<Exercise> exercises = [];

  void neueUebungErstellen() {
    Navigator.push<Widget>(
        context,
        MaterialPageRoute<Widget>(
            builder: (BuildContext context) => neueUebung(
                props: NewExerciseProps(onNotify: onNewExerciseAdded),
                catalogName: widget.uebungskatalogName)));
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var result = await DatabaseService()
          .getExercisesByCatalog(widget.uebungskatalogName);

      setState(() {
        exercises = result;
      });
    });
  }

  Future<void> onNewExerciseAdded(Exercise exercise) async {
    setState(() {
      exercises.add(exercise);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Hauptbildschirm
    return Scaffold(
      //AppBar
      appBar: AppBar(
        //Inhalt
        title: Text(widget.uebungskatalogName,
            style: Theme.of(context).textTheme.headlineMedium),

        //Button Neue Übung erstellen
        actions: [
          IconButton(
            onPressed: neueUebungErstellen,
            icon: const Icon(Icons.add_circle),
            style: Theme.of(context).iconButtonTheme.style,
          )
        ],
      ),

      // Body
      body: ListView.builder(
          itemCount: exercises.length,
          itemBuilder: (context, i) {
            return UkuebungListenelement(widget.props, exercises[i]);
          }),
    );
  }
}
