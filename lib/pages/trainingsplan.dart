import 'package:flutter/material.dart';
import 'package:lak_fitness/styles/color.dart';
import '../models/current_exercise_state.dart';
import '../props/trainingplan_props.dart';
import '../services/database_service.dart';
import 'uebungskatalog.dart';
import '../tp_listelement.dart';

// Startseite
class Trainingsplan extends StatefulWidget {
  final TrainingPlanProps props;

  //Konstruktor
  const Trainingsplan({super.key, required this.props});

  @override
  State<Trainingsplan> createState() => _TrainingsplanState();
}

class _TrainingsplanState extends State<Trainingsplan> {
  List<CurrentExerciseState> exerciseStates = [];
// Übungskatalog öffnen
  void openCatalog() {
    Navigator.push<Widget>(
        context,
        MaterialPageRoute<Widget>(
            builder: (BuildContext context) => UebungskatalogUebersicht(
                props: TrainingPlanProps(
                    trainingPlanName: widget.props.trainingPlanName,
                    onNotify: onNotify))));
  }

  Future<void> onNotify() async {
    var result = await DatabaseService()
        .getExercisesByPlan(widget.props.trainingPlanName);

    setState(() {
      exerciseStates = result;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var result = await DatabaseService()
          .getExercisesByPlan(widget.props.trainingPlanName);
      setState(() {
        exerciseStates = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Hauptbildschirm
    return Scaffold(
      backgroundColor: background,
      //AppBar
      appBar: AppBar(
        //Inhalt
        title: Text(widget.props.trainingPlanName,
            style: Theme.of(context).textTheme.titleLarge),
        // Farbe
        backgroundColor: background,
        //Button zum öffnen des Katalogs
        actions: [
          IconButton(
            onPressed: openCatalog,
            icon: const Icon(Icons.add_circle),
            style: Theme.of(context).iconButtonTheme.style,
          )
        ],
      ),

      // Liste der hinzugefügten Übungen
      body: ListView.builder(
          itemCount: exerciseStates.length,
          itemBuilder: (context, i) {
            return TpListenelement(
                widget.props.trainingPlanName, exerciseStates[i], () async {
              var result = await DatabaseService()
                  .getExercisesByPlan(widget.props.trainingPlanName);

              setState(() {
                exerciseStates = result;
              });
            });
          }),
    );
  }
}
