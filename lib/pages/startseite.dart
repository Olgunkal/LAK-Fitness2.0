import 'package:flutter/material.dart';
import 'package:lak_fitness/styles/color.dart';
import '../models/training_plan.dart';
import '../props/trainingplan_props.dart';
import '../services/database_service.dart';
import '../sts_listelement.dart';

class Startseite extends StatefulWidget {
  //Konstruktor
  const Startseite({super.key});

  @override
  State<Startseite> createState() => _StartseiteState();
}

class _StartseiteState extends State<Startseite> {
  List<TrainingPlan> plans = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var result = await DatabaseService().getTrainingPlans();
      setState(() => plans = result);
    });
  }

  //Neuen Trainingsplan hinzufügen
  Future addTrainingPlan(String name) async {
    var list = await DatabaseService()
        .appendTrainingPlan(TrainingPlan(name: name, exerciseStates: []));

    setState(() {
      plans = list;
      Navigator.pop(context);
    });
  }

  //Funktion Dialog "Neues Training"
  void neuTrainingsplanErstellen() {
    showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          String nameTrainingsplan = "";

          return AlertDialog(
            //Layout Alert Dialog
            elevation: 24.0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),

            //Inhalt
            content: TextField(
              onSubmitted: addTrainingPlan,
              onChanged: (text) {
                nameTrainingsplan = text;
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Trainingsplan",
                hintText: "Trainingsplan${plans.length + 1}",
              ),
            ),
            title: const Text("Neuer Trainingsplan"),
            actions: [
              // Hinzufügen Trainingsplan
              Center(
                child: IconButton(
                    onPressed: () {
                      addTrainingPlan(nameTrainingsplan);
                    },
                    icon: const Icon(Icons.check_circle)),
              )
            ],
          );
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
        title: Text('Home', style: Theme.of(context).textTheme.titleLarge),
        //Farbe
        backgroundColor: background,
        //Button
        actions: [
          IconButton(
            onPressed: neuTrainingsplanErstellen,
            icon: const Icon(Icons.add_circle),
            style: Theme.of(context).iconButtonTheme.style,
          ),
        ],
      ),

      // Body
      body: ListView.builder(
          itemCount: plans.length,
          itemBuilder: (context, i) {
            return StsListenelement(
                TrainingPlanProps(trainingPlanName: plans[i].name));
          }),
    );
  }
}
