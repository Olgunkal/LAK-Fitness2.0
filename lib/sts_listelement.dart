import 'package:flutter/material.dart';
import 'package:lak_fitness/pages/trainingsplan.dart';
import 'package:lak_fitness/props/trainingplan_props.dart';
import 'package:lak_fitness/styles/color.dart';

// Startseite Listenelement
class StsListenelement extends StatelessWidget {
  //Konstruktor
  final TrainingPlanProps props;

  const StsListenelement(this.props, {super.key});

  @override
  Widget build(BuildContext context) {
    void oeffneTrainingsplan() {
      Navigator.push<Widget>(
          context,
          MaterialPageRoute<Widget>(
              builder: (BuildContext context) => Trainingsplan(
                  props: TrainingPlanProps(
                      trainingPlanName: props.trainingPlanName))));
    }

    return Container(
      //Layout
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
          color: background,
          border: Border(bottom: BorderSide(color: purple, width: 2.0))),

      // Listenelemente
      child: ListTile(
        title: Center(
          child: Text(
            props.trainingPlanName,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        onTap: oeffneTrainingsplan,
      ),
    );
  }
}
