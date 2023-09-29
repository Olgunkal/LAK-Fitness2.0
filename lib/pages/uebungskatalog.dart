import 'package:flutter/material.dart';
import '../props/trainingplan_props.dart';
import '../ukuebersicht_listelement.dart';

// Startseite
class UebungskatalogUebersicht extends StatefulWidget {
  final TrainingPlanProps props;

  //Konstruktor
  const UebungskatalogUebersicht({required this.props});

  @override
  State<UebungskatalogUebersicht> createState() =>
      _UebungskatalogUebersichtState();
}

class _UebungskatalogUebersichtState extends State<UebungskatalogUebersicht> {
  // Temporäre Schnittstelle
  List<String> uebungskataloge = ['Bauch', 'Arme', 'Beine'];
  String ueberschriftUebungskatalogUebersicht = "Übungskataloge";

  @override
  Widget build(BuildContext context) {
    // Hauptbildschirm
    return Scaffold(
      //AppBar
      appBar: AppBar(
        //Inhalt
        title: Text(ueberschriftUebungskatalogUebersicht,
            style: Theme.of(context).textTheme.headlineMedium),
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
