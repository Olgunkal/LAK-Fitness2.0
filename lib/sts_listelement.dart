import 'package:flutter/material.dart';
import 'package:lak_fitness/basis_theme.dart';
import 'package:lak_fitness/pages/trainingsplan.dart';

// Startseite Listenelement
class StsListenelement extends StatelessWidget {
  //Konstruktor
  final String trainingsplanName;
  const StsListenelement(this.trainingsplanName, {super.key});

  @override
  Widget build(BuildContext context) {
    void oeffneTrainingsplan() {
      Navigator.push<Widget>(
          context,
          MaterialPageRoute<Widget>(
              builder: (BuildContext context) =>
                  Trainingsplan(trainingsplanName: trainingsplanName)));
    }

    return Container(
      //Layout
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
          color: black,
          border: Border(bottom: BorderSide(color: lila, width: 2.0))),

      // Listenelemente
      child: ListTile(
        title: Center(
          child: Text(
            trainingsplanName,
            style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
        ),
        onTap: oeffneTrainingsplan,
      ),
    );
  }
}
