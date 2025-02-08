import 'dart:io';

import 'package:parking_shared_logic/parking_shared_logic.dart';

class PersonRepository implements InterfaceRepository<Person> {
  final String baseUrl = Platform.isAndroid
      ? "http://10.0.2.2:8080/persons"
      : "http://localhost:8080/persons";

  @override
  Future<Person?> add(Person person) async {
    return await fetchData<Person>(
      url: baseUrl,
      method: 'POST',
      body: person.toJson(),
      fromJson: (data) => Person.fromJson(data),
    );
  }

  @override
  Future<Person?> delete(String id) async {
    return await fetchData<Person>(
      url: '$baseUrl/$id',
      method: 'DELETE',
      fromJson: (data) => Person.fromJson(data),
    );
  }

  @override
  Future<List<Person>> getAll() async {
    return await fetchData<List<Person>>(
      url: baseUrl,
      method: 'GET',
      fromJson: (data) {
        return (data as List).map((person) => Person.fromJson(person)).toList();
      },
    );
  }

  @override
  Future<Person?> getById(String id) async {
    return await fetchData<Person>(
      url: '$baseUrl/$id',
      method: 'GET',
      fromJson: (data) => Person.fromJson(data),
    );
  }

  @override
  Future<Person?> update(String id, Person newItem) async {
    return await fetchData<Person>(
      url: '$baseUrl/$id',
      method: 'PUT',
      body: newItem.toJson(),
      fromJson: (data) => Person.fromJson(data),
    );
  }
}
