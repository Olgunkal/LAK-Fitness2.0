import 'package:flutter/material.dart';
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
  // Temporäre Schnittstelle
  List<String> trainingsplaene = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var result = await DatabaseService().getTrainingPlans();
      setState(() {
        trainingsplaene = result.map((x) => x.name).toList();
      });
    });
  }

  //Neuen Trainingsplan hinzufügen
  Future trainingsplanHinzufuegen(String name) async {
    await DatabaseService()
        .createTrainingPlan(TrainingPlan(name: name, exercises: []));

    setState(() {
      if (name != "") {
        trainingsplaene.add(name);
        Navigator.pop(context);
      }
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
              onSubmitted: trainingsplanHinzufuegen,
              onChanged: (text) {
                nameTrainingsplan = text;
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Trainingsplan",
                hintText: "Trainingsplan${trainingsplaene.length + 1}",
              ),
            ),
            title: const Text("Neuer Trainingsplan"),
            actions: [
              Center(
                child: IconButton(
                    onPressed: () {
                      trainingsplanHinzufuegen(nameTrainingsplan);
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
      //AppBar
      appBar: AppBar(
        //Inhalt
        title: Text('Home', style: Theme.of(context).textTheme.headlineMedium),

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
          itemCount: trainingsplaene.length,
          itemBuilder: (context, i) {
            return StsListenelement(
                TrainingPlanProps(trainingPlanName: trainingsplaene[i]));
          }),
    );
  }
}
