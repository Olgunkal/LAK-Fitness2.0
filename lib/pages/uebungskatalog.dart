import 'package:flutter/material.dart';
import 'package:lak_fitness/styles/color.dart';
import '../props/trainingplan_props.dart';
import '../ukuebersicht_listelement.dart';

// Startseite
class UebungskatalogUebersicht extends StatefulWidget {
  final TrainingPlanProps props;

  //Konstruktor
  const UebungskatalogUebersicht({super.key, required this.props});

  @override
  State<UebungskatalogUebersicht> createState() =>
      _UebungskatalogUebersichtState();
}

class _UebungskatalogUebersichtState extends State<UebungskatalogUebersicht> {
  // Katalogenliste
  List<String> uebungskataloge = ['Brust', 'Beine', 'Rücken', 'Arme', 'Bauch'];
  String ueberschriftUebungskatalogUebersicht = "Übungskataloge";

  @override
  Widget build(BuildContext context) {
    // Hauptbildschirm
    return Scaffold(
      backgroundColor: background,
      //AppBar
      appBar: AppBar(
        //Inhalt
        title: Text(ueberschriftUebungskatalogUebersicht,
            style: Theme.of(context).textTheme.titleLarge),
        // Farbe
        backgroundColor: background,
      ),

      // Body
      body: ListView.builder(
          itemCount: uebungskataloge.length,
          itemBuilder: (context, i) {
            return UkueListenelement(widget.props, uebungskataloge[i]);
          }),
    );
  }
}
