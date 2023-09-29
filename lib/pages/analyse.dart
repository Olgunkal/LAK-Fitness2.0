import 'package:dropdown_search/dropdown_search.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lak_fitness/basis_theme.dart';
import 'package:lak_fitness/styles/color.dart';

import '../services/database_service.dart';

//Analyse Bildschirm

class Analysebildschirm extends StatefulWidget {
  const Analysebildschirm({super.key});

  @override
  State<Analysebildschirm> createState() => _AnalysebildschirmState();
}

class _AnalysebildschirmState extends State<Analysebildschirm> {
  String selectedAnalysisType = "Gewicht";
  String? selectedExercise;

  List<String> availableAnalysisType = <String>[
    "Gewicht",
    "Sätze",
    "Wiederholungen"
  ];

  List<String> exercises = <String>[];
  List<FlSpot> data = [];

  List<String> letzteDaten = <String>[
    DateTime(2022, 01, 01).toString(),
    DateTime(2023, 01, 01).toString()
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var result = await DatabaseService().getExercises();

      setState(() {});
      exercises = result.map((e) => e.name).toList();
    });
  }

  var _datumVon = DateTime(2022, 09, 01);
  var _datumBis = DateTime.now();

  void updateDatumVon(neuesDatum) {
    if (neuesDatum != null) {
      setState(() {
        _datumVon = neuesDatum;
      });
    }
  }

  void updateDatumBis(neuesDatum) {
    if (neuesDatum != null) {
      setState(() {
        _datumBis = neuesDatum;
      });
      print((((_datumBis.millisecondsSinceEpoch.toDouble() -
                          _datumVon.millisecondsSinceEpoch.toDouble()) /
                      86400000.0) /
                  2)
              .round()
              .toDouble() +
          1);
    }
  }

  Future<void> updateData() async {
    var result = await DatabaseService().getTrainingsByName(selectedExercise!);

    if (selectedAnalysisType == 'Gewicht') {
      setState(() {
        data = result
            .map((e) => FlSpot(
                e.date.millisecondsSinceEpoch.toDouble() / 86400000.0,
                e.weight.toDouble()))
            .toList();
      });
    } else if (selectedAnalysisType == 'Sätze') {
      setState(() {
        data = result
            .map((e) => FlSpot(
                e.date.millisecondsSinceEpoch.toDouble() / 86400000.0,
                e.sets.toDouble()))
            .toList();
      });
    } else if (selectedAnalysisType == 'Wiederholungen') {
      setState(() {
        data = result
            .map((e) => FlSpot(
                e.date.millisecondsSinceEpoch.toDouble() / 86400000.0,
                e.repetion.toDouble()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var breite = breiteContainer;
    var _startZeitraum = DateTime(2021); //Zeitpunkt Installation App
    var _endeZeitraum = DateTime(2500);

    //Analysebildschirm
    return Scaffold(
      appBar: AppBar(
        title: Text("Analyse"),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          //Auswahl Analyse nach
          Container(
            width: breite,
            padding: EdgeInsets.all(5),
            child: DropdownButtonFormField(
              value: selectedAnalysisType,
              items: availableAnalysisType.map((String value) {
                return DropdownMenuItem(child: Text(value), value: value);
              }).toList(),
              onChanged: (String? neueAnalyseart) async {
                setState(() {
                  selectedAnalysisType = neueAnalyseart!;
                });

                await updateData();
              },
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Analysieren",
              ),
              style: Theme.of(context).dropdownMenuTheme.textStyle,
            ),
          ),

          //Auswahl Übung
          Container(
            width: breite,
            padding: EdgeInsets.all(5),
            child: DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSelectedItems: true,
                disabledItemFn: (String s) => s.startsWith('I'),
                showSearchBox: true,
              ),
              items: exercises,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow)),
                  labelText: "Übung",
                ),
              ),
              onChanged: (String? value) async {
                setState(() {
                  selectedExercise = value!;
                });

                await updateData();
              },
            ),
          ),

          //Datum von
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: breite / 2,
                  padding: EdgeInsets.all(5),
                  child: ElevatedButton(
                    child: Text("${_datumVon.day.toString()}"
                        ".${_datumVon.month.toString()}."
                        "${_datumVon.year.toString()}"),
                    onPressed: () async {
                      DateTime? _neuDatumVon = await showDatePicker(
                          context: context,
                          initialDate: _datumVon,
                          firstDate: _startZeitraum,
                          lastDate: _endeZeitraum);
                      updateDatumVon(_neuDatumVon);
                    },
                  )),
              Container(
                  width: breite / 2,
                  padding: EdgeInsets.all(5),
                  child: ElevatedButton(
                    child: Text("${_datumBis.day.toString()}"
                        ".${_datumBis.month.toString()}."
                        "${_datumBis.year.toString()}"),
                    onPressed: () async {
                      DateTime? _neuDatumBis = await showDatePicker(
                          context: context,
                          initialDate: _datumBis,
                          firstDate: _startZeitraum,
                          lastDate: _endeZeitraum);
                      updateDatumBis(_neuDatumBis);
                    },
                  ))
            ],
          ),
          Container(
              width: breite + 50.0,
              height: 400.0,
              child: LineChart(LineChartData(
                minY: 10.0,
                maxY: 20.0,
                minX: _datumVon.millisecondsSinceEpoch.toDouble() / 86400000.0,
                maxX: _datumBis.millisecondsSinceEpoch.toDouble() / 86400000.0,
                lineBarsData: [
                  LineChartBarData(
                    spots: data,
                    color: white,
                    belowBarData: BarAreaData(
                      show: true,
                      color: white.withOpacity(0.3),
                    ),
                  )
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30.0,
                          getTitlesWidget: (value, meta) {
                            var date = DateTime.fromMillisecondsSinceEpoch(
                                (value * 86400000.0).toInt());
                            return SideTitleWidget(
                              child: Text(
                                "${date.day.toString()}."
                                "${date.month.toString()}."
                                "${date.year.toString()}",
                                textAlign: TextAlign.center,
                              ),
                              axisSide: meta.axisSide,
                              space: 10.0,
                            );
                          },
                          interval: (((_datumBis.millisecondsSinceEpoch
                                                  .toDouble() -
                                              _datumVon.millisecondsSinceEpoch
                                                  .toDouble()) /
                                          86400000.0) /
                                      2)
                                  .round()
                                  .toDouble() +
                              1)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                    border: Border.all(
                  color: lila,
                )),
                gridData: FlGridData(
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: lila,
                      );
                    }),
              ))),
        ],
      )),
    );
  }
}
