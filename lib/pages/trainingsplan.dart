import 'package:flutter/material.dart';
import 'package:lak_fitness/pages/uebungskatalog.dart';
import '../tp_listelement.dart';

// Startseite
class Trainingsplan extends StatefulWidget {
  final String trainingsplanName;

  //Konstruktor
  Trainingsplan({required this.trainingsplanName});

  @override
  State<Trainingsplan> createState() => _TrainingsplanState();
}

class _TrainingsplanState extends State<Trainingsplan> {
  // Temporäre Schnittstelle
  List<String> uebungen = ['Schrägbankdrücken', 'Liegestüz', 'Dips'];
  //String ueberschriftUebung = widget.trainingsplanName;

  //Funktion Dialog "Neues Training"
  void neuUebungHinzufuegen() {
    Navigator.push<Widget>(
        context,
        MaterialPageRoute<Widget>(
            builder: (BuildContext context) => UebungskatalogUebersicht()));
  }

  @override
  Widget build(BuildContext context) {
    // Hauptbildschirm
    return Scaffold(
      //AppBar
      appBar: AppBar(
        //Inhalt
        title: Text(widget.trainingsplanName,
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
          itemCount: uebungen.length,
          itemBuilder: (context, i) {
            return TpListenelement(uebungen[i]);
          }),
    );
  }
}
