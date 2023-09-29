import 'exercise.dart';

class TrainingPlan {
  String name;
  List<Exercise> exercises = [];

  TrainingPlan({required this.name, required this.exercises});

  TrainingPlan.fromJson(Map<String, dynamic>? json)
      : this(
            name: json!['Name'],
            exercises: List<Exercise>.from(
                json['Übungen'].map((x) => Exercise.fromJson(x))));

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Übungen': List<dynamic>.from(exercises.map((x) => x.toJson()))
    };
  }
}
