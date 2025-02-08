import 'dart:convert';
import 'package:parking_server/repositories/index.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

ParkingSpaceDataStore parkingSpaceRepo = ParkingSpaceDataStore();

Future<Response> postParkingSpaceHandler(Request req) async {
  try {
    final data = await req.readAsString();
    final json = jsonDecode(data);

    ParkingSpace? parkingSpace = ParkingSpace.fromJson(json);

    parkingSpace = await parkingSpaceRepo.add(parkingSpace);

    return Response.ok(jsonEncode(parkingSpace),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
        body: jsonEncode({'error': 'Something went wrong: ${e.toString()}'}),
        headers: {'Content-Type': 'application/json'});
  }
}

Future<Response> getParkingSpacesHandler(Request req) async {
  try {
    var parkingSpaces = await parkingSpaceRepo.getAll();

    final payload = parkingSpaces.map((parkingSpace) => parkingSpace.toJson()).toList();

    return Response.ok(jsonEncode(payload),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'error': 'Something went wrong: ${e.toString()}'}),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> putParkingSpaceHandler(Request req) async {
  try {
    final id = req.params['id'];
    var parkingSpace = await parkingSpaceRepo.getById(id!);

    if (parkingSpace == null) {
      return Response.notFound(
          (body: jsonEncode({'error': 'Parkingspace not found'})));
    }

    final data = await req.readAsString();
    parkingSpace = updateParkingSpace(parkingSpace, data);

    await parkingSpaceRepo.update(parkingSpace.id, parkingSpace);

    return Response.ok(jsonEncode(parkingSpace.toJson()),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'error': 'Something went wrong: ${e.toString()}'}),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> getParkingSpaceHandler(Request req) async {
  final id = req.params['id'];

  try {
    var parkingSpace = await parkingSpaceRepo.getById(id!);

    if (parkingSpace == null) {
      return Response.notFound((
        body: jsonEncode({'error': 'Parkingspace not found'}),
        headers: {'Content-Type': 'application/json'}
      ));
    }

    return Response.ok(jsonEncode(parkingSpace),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode(({'error': 'Something went wrong: ${e.toString()}'})),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> deleteParkingSpaceHandler(Request req) async {
  final id = req.params['id'];

  try {
    var parkingSpace = await parkingSpaceRepo.getById(id!);

    if (parkingSpace == null) {
      return Response.notFound((
        body: jsonEncode({'error': 'Parkingspace not found'}),
        headers: {'Content-Type': 'application/json'}
      ));
    }
    await parkingSpaceRepo.delete(parkingSpace.id);

    return Response.ok(jsonEncode(parkingSpace),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode(({'error': 'Something went wrong: ${e.toString()}'})),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

ParkingSpace updateParkingSpace(ParkingSpace parkingSpace, String json) {
  var data = jsonDecode(json) as Map<String, dynamic>;
  if (data['address'] != null) {
    parkingSpace.address = data['address'];
  }
  
  if (data['pricePerHour'] != null) {
    parkingSpace.pricePerHour = data['pricePerHour'];
  }

  return parkingSpace;
}
