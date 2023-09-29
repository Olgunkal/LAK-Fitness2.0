import 'package:intl/intl.dart';

class Training {
  DateTime date;
  String exercise;
  int weight;
  int repetion;
  int sets;

  Training(
      {required this.date,
      required this.exercise,
      required this.weight,
      required this.repetion,
      required this.sets});

  Training.fromJson(Map<String, dynamic>? json)
      : this(
            date: DateTime.parse(json!['Datum']),
            exercise: json['Übung'],
            weight: json['Gewicht'],
            repetion: json['Wiederholungen'],
            sets: json['Sätze']);

  Map<String, dynamic> toJson() {
    return {
      'Datum': DateFormat('yyyy-MM-dd').format(date),
      'Übung': exercise,
      'Gewicht': weight,
      'Wiederholungen': repetion,
      'Sätze': sets
    };
  }
}
