import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartTest extends StatelessWidget {
  //Trainingsdaten
  List<FlSpot> trainingsdata2 = <FlSpot>[
    FlSpot(1.0, 10.0),
    FlSpot(2.0, 12.0),
    FlSpot(3.0, 15.0),
    FlSpot(4.0, 12.0),
    FlSpot(5.0, 17.0)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //AppBar
        appBar: AppBar(
          //Inhalt
          title:
              Text('Home', style: Theme.of(context).textTheme.headlineMedium),
        ),

        // Body
        body: SizedBox(
          width: 200.0,
          height: 400.0,
          child: LineChart(LineChartData(
              minX: 1.0,
              maxX: 10.0,
              minY: 10.0,
              maxY: 20.0,
              lineBarsData: [LineChartBarData(spots: trainingsdata2)])),
        ));
  }
}
