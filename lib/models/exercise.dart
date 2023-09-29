class Exercise {
  String name;
  String description;

  Exercise({required this.name, required this.description});

  Exercise.fromJson(Map<String, dynamic>? json)
      : this(name: json!['Name'], description: json['Beschreibung']);

  Map<String, dynamic> toJson() {
    return {'Name': name, 'Beschreibung': description};
  }
}
