import 'package:intl/intl.dart';
import 'package:lak_fitness/models/training_plan.dart';
import 'package:lak_fitness/models/traning.dart';

class LakUser {
  int weight;
  int height;
  String email;
  String username;
  DateTime birthday;

  // List<Traning> traning;
  List<TrainingPlan> plans = [];
  // TrainingPlan[] plans;

  LakUser(
      {required this.email,
      required this.username,
      required this.birthday,
      required this.weight,
      required this.height,
      required this.plans});

  LakUser.fromJson(Map<String, dynamic>? json)
      : this(
            email: json!['Email'],
            weight: json['Gewicht'],
            height: json['Größe'],
            birthday: DateTime.parse(json['Geburtsdatum']),
            username: json['Benutzername'],
            plans: List<TrainingPlan>.from(
                json['Plans'].map((x) => TrainingPlan.fromJson(x))));

  Map<String, dynamic> toJson() {
    return {
      'Email': email,
      'Benutzername': username,
      'Geburtsdatum': DateFormat('yyyy-MM-dd').format(birthday),
      'Gewicht': weight,
      'Größe': height,
      'Plans': List<dynamic>.from(plans!.map((x) => x.toJson()))
    };
  }
}
