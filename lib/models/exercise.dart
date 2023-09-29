import 'package:uuid/uuid.dart';

class Exercise {
  String id;
  String name;
  String description;
  String catalog;

  Exercise(
      {required this.id,
      required this.name,
      required this.description,
      required this.catalog});
  // Erstellung der Übung in der Datenbank im Katalog
  Exercise.fromJson(Map<String, dynamic>? json)
      : this(
            id: json!['Id'] ?? const Uuid().v1(),
            name: json['Name'],
            description: json['Beschreibung'],
            catalog: json['Übungskatalog']);
  // Befüllen der Werte der Felder in der Datenbank
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'Beschreibung': description,
      'Übungskatalog': catalog
    };
  }
}
