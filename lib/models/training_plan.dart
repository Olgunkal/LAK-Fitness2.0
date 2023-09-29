import 'current_exercise_state.dart';

class TrainingPlan {
  String name;
  List<CurrentExerciseState> exerciseStates = [];

  TrainingPlan({required this.name, required this.exerciseStates});
// Hinzufügen der Übung in der Datenbank im Trainingsplan
  TrainingPlan.fromJson(Map<String, dynamic>? json)
      : this(
            name: json!['Name'],
            exerciseStates: List<CurrentExerciseState>.from(
                json['Übungen'].map((x) => CurrentExerciseState.fromJson(x))));
  // Befüllen der Werte der Felder in der Datenbank
  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Übungen': List<dynamic>.from(exerciseStates.map((x) => x.toJson()))
    };
  }
}
