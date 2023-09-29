import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lak_fitness/services/database_service.dart';
import 'package:lak_fitness/styles/color.dart';
import 'basis_theme.dart';
import 'models/current_exercise_state.dart';

// Startseite Listenelement
class TpListenelement extends StatefulWidget {
  final CurrentExerciseState exerciseState;
  final String trainingPlanName;
  final Function() onRemoved;

  const TpListenelement(
      this.trainingPlanName, this.exerciseState, this.onRemoved,
      {super.key});

  @override
  State<TpListenelement> createState() => _TpListenelementState();
}

class _TpListenelementState extends State<TpListenelement> {
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
                  onPressed: (context) async => await removeExercise())
            ],
          ),
          child: Center(
            child: ExpansionTile(
              title: Center(
                  child: Text(
                widget.exerciseState.exercise.name,
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
                            hintText: widget.exerciseState.sets.toString()),
                        onChanged: (value) async {
                          setState(() {
                            widget.exerciseState.sets = int.parse(value);
                          });

                          await DatabaseService().updateExerciseState(
                              widget.trainingPlanName, widget.exerciseState);
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
                              hintText:
                                  widget.exerciseState.repetions.toString()),
                          onChanged: (value) async {
                            setState(() {
                              widget.exerciseState.repetions = int.parse(value);
                            });

                            await DatabaseService().updateExerciseState(
                                widget.trainingPlanName, widget.exerciseState);
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
                          ),
                          onChanged: (value) async {
                            setState(() {
                              widget.exerciseState.weight = int.parse(value);
                            });

                            await DatabaseService().updateExerciseState(
                                widget.trainingPlanName, widget.exerciseState);
                          },
                        ))),
              ],
            ),
          )),
    );
  }

  checkoutUebung() {}

  Future<void> removeExercise() async {
    await DatabaseService().removeExercise(
        widget.trainingPlanName, widget.exerciseState.exercise.name);

    widget.onRemoved();
  }
}
