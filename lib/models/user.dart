import 'package:intl/intl.dart';
import 'package:lak_fitness/models/training.dart';
import 'package:lak_fitness/models/training_plan.dart';

class LakUser {
  int weight;
  int height;
  String email;
  String username;
  DateTime birthday;

  List<TrainingPlan> plans = [];
  List<Training> trainings;

  LakUser(
      {required this.email,
      required this.username,
      required this.birthday,
      required this.weight,
      required this.height,
      required this.plans,
      required this.trainings});

  LakUser.fromJson(Map<String, dynamic>? json)
      : this(
            email: json!['Email'],
            weight: json['Gewicht'],
            height: json['Größe'],
            birthday: DateTime.parse(json['Geburtsdatum']),
            username: json['Benutzername'],
            plans: List<TrainingPlan>.from(
                json['Plans'].map((x) => TrainingPlan.fromJson(x))),
            trainings: List<Training>.from(
                json['Trainings'].map((x) => Training.fromJson(x))));

  Map<String, dynamic> toJson() {
    return {
      'Email': email,
      'Benutzername': username,
      'Geburtsdatum': DateFormat('yyyy-MM-dd').format(birthday),
      'Gewicht': weight,
      'Größe': height,
      'Plans': List<dynamic>.from(plans!.map((x) => x.toJson())),
      'Trainings': List<dynamic>.from(trainings.map((x) => x.toJson()))
    };
  }
}
