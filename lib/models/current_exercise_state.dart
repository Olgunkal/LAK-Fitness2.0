import 'exercise.dart';

// Akutelle Übungen die im Trainingsplan sind
class CurrentExerciseState {
  Exercise exercise;
  int weight;
  int sets;
  int repetions;

  CurrentExerciseState(
      {required this.exercise,
      required this.weight,
      required this.sets,
      required this.repetions});

  CurrentExerciseState.fromJson(Map<String, dynamic>? json)
      : this(
            exercise: Exercise.fromJson(json!['Übung']),
            weight: json['Gewicht'],
            sets: json['Sätze'],
            repetions: json['Wiederholungen']);

  Map<String, dynamic> toJson() {
    return {
      'Übung': exercise.toJson(),
      'Gewicht': weight,
      'Sätze': sets,
      'Wiederholungen': repetions
    };
  }
}
