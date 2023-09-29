import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lak_fitness/services/database_service.dart';
import 'package:lak_fitness/styles/color.dart';
import 'basis_theme.dart';

// Startseite Listenelement
class TpListenelement extends StatefulWidget {
  final String uebungName;
  final String trainingsplanName;
  final Function() onRemoved;

  const TpListenelement(this.trainingsplanName, this.uebungName, this.onRemoved,
      {super.key});

  @override
  State<TpListenelement> createState() => _TpListenelementState();
}

class _TpListenelementState extends State<TpListenelement> {
  int _saetze = 0;
  int _wiederholungen = 0;
  double _gewicht = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      //Layout
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
          color: black,
          border: Border(bottom: BorderSide(color: lila, width: 2.0))),

      // Listenelemente
      child: Slidable(
          startActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                  icon: Icons.check,
                  backgroundColor: Colors.green,
                  onPressed: checkoutUebung())
            ],
          ),
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                  icon: Icons.delete_forever,
                  backgroundColor: Colors.red,
                  onPressed: (context) async =>
                      await entferneUebung(widget.uebungName))
            ],
          ),
          child: Center(
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
              children: [
                ListTile(
                  title: const Text('Sätze'),
                  trailing: Container(
                      width: 50,
                      margin: EdgeInsets.all(10),
                      child: TextField(
                        textAlign: TextAlign.center,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: white)),
                            hintText: _saetze.toString()),
                        onChanged: (value) {
                          setState(() {
                            _saetze = int.parse(value);
                          });
                        },
                      )),
                ),
                ListTile(
                    title: Text('Wiederholungen'),
                    trailing: Container(
                        width: 50,
                        margin: EdgeInsets.all(10),
                        child: TextField(
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: white)),
                              hintText: _wiederholungen.toString()),
                          onChanged: (value) {
                            setState(() {
                              _wiederholungen = int.parse(value);
                            });
                          },
                        ))),
                ListTile(
                    title: Text('Gewicht'),
                    trailing: Container(
                        width: 50,
                        margin: EdgeInsets.all(10),
                        child: TextField(
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: white)),
                            //hintText: (_gewicht as int).toString()
                          ),
                          onChanged: (value) {
                            setState(() {
                              _gewicht = double.parse(value);
                            });
                          },
                        ))),
              ],
            ),
          )),
    );
  }

  checkoutUebung() {}

  Future<void> entferneUebung(String name) async {
    await DatabaseService()
        .removeExercise(widget.trainingsplanName, widget.uebungName);

    widget.onRemoved();
  }
}
