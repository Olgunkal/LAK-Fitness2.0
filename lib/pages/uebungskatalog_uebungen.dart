import 'package:flutter/material.dart';
import '../ukuebung_listelement.dart';
import 'neuUebung.dart';

// Startseite
class UebungskatalogUebungen extends StatefulWidget {
  //Überschirft mit Name des Übungskatalogs
  final String uebungskatalogName;

  //Konstruktor
  UebungskatalogUebungen({required this.uebungskatalogName});

  @override
  State<UebungskatalogUebungen> createState() => _UebungskatalogUebungenState();
}

class _UebungskatalogUebungenState extends State<UebungskatalogUebungen> {
  // Temporäre Schnittstelle
  List<String> uebungskataloge = ['Sit-Ups', 'Crunches', 'Klappmesser'];

  void neueUebungErstellen() {
    Navigator.push<Widget>(
        context,
        MaterialPageRoute<Widget>(
            builder: (BuildContext context) => neueUebung()));
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
          itemCount: uebungskataloge.length,
          itemBuilder: (context, i) {
            return UkuebungListenelement(uebungskataloge[i]);
          }),
    );
  }
}
