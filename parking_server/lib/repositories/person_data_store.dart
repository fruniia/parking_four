import 'dart:io';
import 'dart:convert';

import 'package:parking_shared_logic/parking_shared_logic.dart';

class PersonDataStore implements InterfaceRepository<Person> {
  String filePath = '../parking_server/persons.json';

  @override
  Future<List<Person>> getAll() async {
    try {
      final file = File(filePath);

      if (!await file.exists()) {
        return [];
      }
      final content = await file.readAsString();
      final List<dynamic> data = jsonDecode(content);
      return data.map((person) => Person.fromJson(person)).toList();
    } catch (e) {
      print('Error reading file: ${e.toString()}');
      return [];
    }
  }

  @override
  Future<Person?> add(Person person) async {
    final file = File(filePath);
    final List<Person> persons = await getAll();

    persons.add(person);

    if (!await file.exists()) {
      await file.create(exclusive: true);
    }

    await file.writeAsString(jsonEncode(persons));
    return person;
  }

  @override
  Future<Person?> update(String index, Person newItem) async {
    final file = File(filePath);

    if (!await file.exists()) {
      await file.create();
    }

    String fileContent = await file.readAsString();

    List<Person> persons = _getPersons(fileContent);

    for (var i = 0; i < persons.length; i++) {
      if (persons[i].id == index) {
        persons[i] = newItem;

        await file.writeAsString(
            jsonEncode(persons.map((person) => person.toJson()).toList()));

        return newItem;
      }
    }
    return null;
  }

  @override
  Future<Person?> delete(String index) async {
    final file = File(filePath);

    if (!await file.exists()) {
      await file.create();
    }

    String fileContent = await file.readAsString();
    List<Person> persons = _getPersons(fileContent);

    for (var i = 0; i < persons.length; i++) {
      if (persons[i].id == index) {
        final person = persons.removeAt(i);

        await file.writeAsString(
            jsonEncode(persons.map((person) => person.toJson()).toList()));

        return person;
      }
    }
    return null;
  }

  List<Person> _getPersons(String fileContent) {
    List<Person> persons = (jsonDecode(fileContent) as List)
        .map((json) => Person.fromJson(json))
        .toList();
    return persons;
  }

  @override
  Future<Person?> getById(String id) async {
    final file = File(filePath);
    if (!await file.exists()) {
      await file.create();
    }

    String fileContent = await file.readAsString();
    List<Person> persons = _getPersons(fileContent);

    for (var person in persons) {
      if (person.id == id) {
        return person;
      }
    }
    return null;
  }
}
