import 'package:dropdown_search/dropdown_search.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lak_fitness/styles/color.dart';

import '../services/database_service.dart';

//Analyse Bildschirm

class Analysebildschirm extends StatefulWidget {
  const Analysebildschirm({super.key});

  @override
  State<Analysebildschirm> createState() => _AnalysebildschirmState();
}

class _AnalysebildschirmState extends State<Analysebildschirm> {
  // Default Wert für Analyse
  String selectedAnalysisType = "Gewicht";
  String? selectedExercise;

  //Möglichkeiten der Kategorien nach denen gefiltert werden kann
  List<String> availableAnalysisType = <String>[
    "Gewicht",
    "Sätze",
    "Wiederholungen"
  ];

  List<String> exercises = <String>[];
  List<FlSpot> data = [];

  //Defaultwerte Filter-Datum
  List<String> letzteDaten = <String>[
    DateTime(2022, 01, 01).toString(),
    DateTime(2023, 01, 01).toString()
  ];

  var _datumVon = DateTime(2022, 09, 01);
  var _datumBis = DateTime.now();

  //Initialisierung des Status
  @override
  void initState() {
    super.initState();

    //Aktualisierung bei der Übung aus der Datenbank gelesen werden
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      var result = await DatabaseService().getExercises();

      setState(() {});
      exercises = result.map((e) => e.name).toList();
    });
  }

  //Funktioenn zum updaten des Datums
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
    }
  }

  //Anfrage der Trainingsdaten des aktuellen Nutzers aus der Datenbank
  Future<void> updateData() async {
    var result = await DatabaseService().getTrainingsByName(selectedExercise!);

    // Abfrage Gewicht
    if (selectedAnalysisType == 'Gewicht') {
      setState(() {
        data = result
            .map((e) => FlSpot(
                e.date.millisecondsSinceEpoch.toDouble() / 86400000.0,
                e.weight.toDouble()))
            .toList();
      });

      // Abfrage Sätze
    } else if (selectedAnalysisType == 'Sätze') {
      setState(() {
        data = result
            .map((e) => FlSpot(
                e.date.millisecondsSinceEpoch.toDouble() / 86400000.0,
                e.sets.toDouble()))
            .toList();
      });

      //Abfrage Wiederholung
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
    //Layoutbreite (aus basis_theme.dart)

    //Eingrenzung Zeitraum DatePicker
    var startZeitraum = DateTime(2021);
    var endeZeitraum = DateTime(2500);

    //Analysebildschirm
    return Scaffold(
      // AppBar
      appBar: AppBar(
        title: const Text("Analyse"),
      ),

      //Body
      body: Center(
          child: Column(
        children: <Widget>[
          //Auswahl Analyse nach
          Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(top: 20, left: 60, right: 60),
            child:
                //DropDown Liste mit Kategorien nach denen gefiltert werden kann
                DropdownButtonFormField(
              value: selectedAnalysisType,
              items: availableAnalysisType.map((String value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              onChanged: (String? neueAnalyseart) async {
                setState(() {
                  selectedAnalysisType = neueAnalyseart!;
                });

                await updateData();
              },

              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Analysieren",
              ),

              //Style des DropDown Menüs aus basis_theme.dart
              style: Theme.of(context).dropdownMenuTheme.textStyle,
            ),
          ),

          //Auswahl Übung
          Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.symmetric(horizontal: 60),
            child:

                //DropDown zur Auswahl einer Übung, nach der gefiltert werden soll
                DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSelectedItems: true,
                disabledItemFn: (String s) => s.startsWith('I'),
                showSearchBox: true,
              ),
              items: exercises,
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
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

          //Auswahl Datum von
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.symmetric(vertical: 5),

                  //Auswahl als Button
                  child: ElevatedButton(
                    child: Text(
                      "${_datumVon.day.toString()}"
                      ".${_datumVon.month.toString()}."
                      "${_datumVon.year.toString()}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () async {
                      //DatePicker zur Kalenderauswahl
                      DateTime? neuDatumVon = await showDatePicker(
                          context: context,
                          initialDate: _datumVon,
                          firstDate: startZeitraum,
                          lastDate: endeZeitraum);
                      updateDatumVon(neuDatumVon);
                    },
                  )),

              //Auswahl Datum bis
              Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.symmetric(vertical: 5),

                  //Auswahl als Button
                  child: ElevatedButton(
                    child: Text(
                        "${_datumBis.day.toString()}"
                        ".${_datumBis.month.toString()}."
                        "${_datumBis.year.toString()}",
                        style: const TextStyle(fontSize: 16)),
                    onPressed: () async {
                      //DatePicker zur Kalenderauswahl
                      DateTime? neuDatumBis = await showDatePicker(
                          context: context,
                          initialDate: _datumBis,
                          firstDate: startZeitraum,
                          lastDate: endeZeitraum);
                      updateDatumBis(neuDatumBis);
                    },
                  ))
            ],
          ),

          //Darstellung Graph
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              height: 400.0,
              child: LineChart(LineChartData(
                minY: 10.0,
                maxY: 20.0,
                minX: _datumVon.millisecondsSinceEpoch.toDouble() / 86400000.0,
                maxX: _datumBis.millisecondsSinceEpoch.toDouble() / 86400000.0,

                //Formatierung Graph
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

                //Formatierung der Achsentitel
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30.0,
                          getTitlesWidget: (value, meta) {
                            var date = DateTime.fromMillisecondsSinceEpoch(
                                (value * 86400000.0).toInt());
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 10.0,
                              child: Text(
                                "${date.day.toString()}."
                                "${date.month.toString()}."
                                "${date.year.toString()}",
                                textAlign: TextAlign.center,
                              ),
                            );
                          },

                          //Maximal 3 Beschriftung auf der x-Achse
                          interval: (((_datumBis.millisecondsSinceEpoch
                                                  .toDouble() -
                                              _datumVon.millisecondsSinceEpoch
                                                  .toDouble()) /
                                          86400000.0) /
                                      2)
                                  .round()
                                  .toDouble() +
                              1)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),

                //Formatierung Umrandung
                borderData: FlBorderData(
                    border: Border.all(
                  color: purple,
                )),

                //Formatierung Raster
                gridData: FlGridData(
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: purple,
                      );
                    }),
              ))),
        ],
      )),
    );
  }
}
