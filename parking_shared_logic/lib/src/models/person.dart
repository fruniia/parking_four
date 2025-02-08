import 'package:uuid/uuid.dart';

class Person {
  String id;
  String name;
  String socialSecNumber;

  Person({required this.id, required this.name, required this.socialSecNumber});

  Person.withUUID({
    required this.name,
    required this.socialSecNumber,
  }) : id = Uuid().v4();

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
        id: json['id'],
        name: json['name'],
        socialSecNumber: json['socialSecNumber']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'socialSecNumber': socialSecNumber};
  }
}
