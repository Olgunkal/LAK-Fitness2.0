class TrainingPlan {
  String name;

  TrainingPlan({required this.name});

  TrainingPlan.fromJson(Map<String, dynamic>? json) : this(name: json!['Name']);

  Map<String, dynamic> toJson() {
    return {'Name': name};
  }
}
