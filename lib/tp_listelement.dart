import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:lak_fitness/basis_theme.dart';

// Startseite Listenelement
class TpListenelement extends StatefulWidget {
  //Konstruktor
  final String uebungName;
  const TpListenelement(this.uebungName, {super.key});

  @override
  State<TpListenelement> createState() => _TpListenelementState();
}

class _TpListenelementState extends State<TpListenelement> {
  double _saetze = 0.0;
  int _wiederholungen = 0;
  int _gewicht = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      //Layout
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
          color: black,
          border: Border(bottom: BorderSide(color: lila, width: 2.0))),

      // Listenelemente
      child: ListTile(
        title: Center(
            child: ExpansionTile(
          title: Center(
              child: Text(
            widget.uebungName,
            style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          )),
          trailing: const Text(""),
          collapsedBackgroundColor: grey,
          children: [
            ListTile(
                title: const Text('Sätze'),
                trailing: Container(
                  width: 50,
                  child: SpinBox(
                    value: _saetze,
                    onChanged: (double value) {
                      setState(() {
                        _saetze = value;
                      });
                    },
                    decoration: const InputDecoration(),
                  ),
                )),
            const ListTile(
              title: Text('Wiederholungen'),
            ),
            const ListTile(
              title: Text('Gewicht'),
            ),
          ],
        )),
      ),
    );
  }
}
