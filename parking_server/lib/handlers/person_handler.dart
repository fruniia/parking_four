import 'dart:convert';

import 'package:parking_server/repositories/index.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

PersonDataStore personRepo = PersonDataStore();

Future<Response> postPersonHandler(Request req) async {
  try {
    final data = await req.readAsString();
    final json = jsonDecode(data);

    Person? person = Person.fromJson(json);

    person = await personRepo.add(person);

    return Response.ok(jsonEncode(person),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
        body: jsonEncode({'error': 'Something went wrong: ${e.toString()}'}),
        headers: {'Content-Type': 'application/json'});
  }
}

Future<Response> putPersonHandler(Request req) async {
  final id = req.params['id'];
  final data = await req.readAsString();

  final json = jsonDecode(data) as Map<String, dynamic>;

  final name = json['name'];

  if (name == null) {
    return Response.badRequest(
      body: jsonEncode({'error': 'Name must not be null'}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  final person = await personRepo.getById(id!);

  if (person == null) {
    return Response.notFound((body: jsonEncode({'error': 'Person not found'})));
  }

  person.name = name;
  await personRepo.update(person.id, person);

  return Response.ok(jsonEncode(person.toJson()),
      headers: {'Content-Type': 'application/json'});
}

Future<Response> getPersonsHandler(Request req) async {
  try {
    var persons = await personRepo.getAll();

    final payload = persons.map((person) => person.toJson()).toList();

    return Response.ok(jsonEncode(payload),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'error': 'Something went wrong: ${e.toString()}'}),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> getPersonHandler(Request req) async {
  final id = req.params['id'];

  try {
    var person = await personRepo.getById(id!);

    if (person == null) {
      return Response.notFound((
        body: jsonEncode({'error': 'Person not found'}),
        headers: {'Content-Type': 'application/json'}
      ));
    }

    return Response.ok(jsonEncode(person),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode(({'error': 'Something went wrong: ${e.toString()}'})),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> deletePersonHandler(Request req) async {
  final id = req.params['id'];

  try {
    var person = await personRepo.getById(id!);

    if (person == null) {
      return Response.notFound((
        body: jsonEncode({'error': 'Person not found'}),
        headers: {'Content-Type': 'application/json'}
      ));
    }
    await personRepo.delete(person.id);

    return Response.ok(jsonEncode(person),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode(({'error': 'Something went wrong: ${e.toString()}'})),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
