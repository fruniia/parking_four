import 'dart:convert';

import 'package:parking_server/repositories/index.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

ParkingDataStore parkingRepo = ParkingDataStore();

Future<Response> postParkingHandler(Request req) async {
  try {
    final data = await req.readAsString();
    final json = jsonDecode(data);

    Parking? parking = Parking.fromJson(json);

    parking = await parkingRepo.add(parking);

    return Response.ok(jsonEncode(parking),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
        body: jsonEncode({'error': 'Something went wrong: ${e.toString()}'}),
        headers: {'Content-Type': 'application/json'});
  }
}

Future<Response> getParkingsHandler(Request req) async {
  try {
    var parkings = await parkingRepo.getAll();

    final payload = parkings.map((parking) => parking.toJson()).toList();

    return Response.ok(jsonEncode(payload),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'error': 'Something went wrong: ${e.toString()}'}),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> putParkingHandler(Request req) async {
  try {
    final id = req.params['id'];
    var parking = await parkingRepo.getById(id!);

    if (parking == null) {
      return Response.notFound(
          (body: jsonEncode({'error': 'Parking not found'})));
    }

    final data = await req.readAsString();
    parking = updateParking(parking, data);

    await parkingRepo.update(parking.id, parking);

    return Response.ok(jsonEncode(parking.toJson()),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'error': 'Something went wrong: ${e.toString()}'}),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> getParkingHandler(Request req) async {
  final id = req.params['id'];

  try {
    var parking = await parkingRepo.getById(id!);

    if (parking == null) {
      return Response.notFound((
        body: jsonEncode({'error': 'Parking not found'}),
        headers: {'Content-Type': 'application/json'}
      ));
    }

    return Response.ok(jsonEncode(parking),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode(({'error': 'Something went wrong: ${e.toString()}'})),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> deleteParkingHandler(Request req) async {
  final id = req.params['id'];

  try {
    var parking = await parkingRepo.getById(id!);

    if (parking == null) {
      return Response.notFound((
        body: jsonEncode({'error': 'Parking not found'}),
        headers: {'Content-Type': 'application/json'}
      ));
    }
    await parkingRepo.delete(parking.id);

    return Response.ok(jsonEncode(parking),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode(({'error': 'Something went wrong: ${e.toString()}'})),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Parking updateParking(Parking parking, String json) {
  var data = jsonDecode(json) as Map<String, dynamic>;
  if (data.containsKey('vehicle')) {
    parking.vehicle = Vehicle.fromJson(data['vehicle']);
  }

  if (data.containsKey('parkingSpace')) {
    parking.parkingSpace = ParkingSpace.fromJson(data['parkingSpace']);
  }

  if (data.containsKey('start')) {
    var newStartTime = DateTime.parse(data['start']);
    parking.updateStart(newStartTime);
  }
  
  if (data.containsKey('stop')) {
    if (data['stop'] != null) {
      var newStopTime = DateTime.parse(data['stop']);
      parking.updateStop(newStopTime);
    } else {
      parking.updateStop(null); // Set stop to null if it's explicitly null
    }
  }
  return parking;
}
