import 'dart:convert';

import 'package:parking_server/repositories/index.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

VehicleDataStore vehicleRepo = VehicleDataStore();

Future<Response> postVehicleHandler(Request req) async {
  try {
    final data = await req.readAsString();
    final json = jsonDecode(data);

    Vehicle? vehicle = Vehicle.fromJson(json);

    vehicle = await vehicleRepo.add(vehicle);

    return Response.ok(jsonEncode(vehicle),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
        body: jsonEncode({'error': 'Something went wrong: ${e.toString()}'}),
        headers: {'Content-Type': 'application/json'});
  }
}

Future<Response> getVehiclesHandler(Request req) async {
  try {
    var vehicles = await vehicleRepo.getAll();

    final payload = vehicles.map((vehicle) => vehicle.toJson()).toList();

    return Response.ok(jsonEncode(payload),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'error': 'Something went wrong: ${e.toString()}'}),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> putVehicleHandler(Request req) async {
  try {
    final id = req.params['id'];
    var vehicle = await vehicleRepo.getById(id!);

    if (vehicle == null) {
      return Response.notFound(
          (body: jsonEncode({'error': 'Vehicle not found'})));
    }
    final data = await req.readAsString();
    vehicle = updateVehicle(vehicle, data);
    await vehicleRepo.update(vehicle.id, vehicle);

    return Response.ok(jsonEncode(vehicle.toJson()),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode({'error': 'Something went wrong: ${e.toString()}'}),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> getVehicleHandler(Request req) async {
  final id = req.params['id'];

  try {
    var vehicle = await vehicleRepo.getById(id!);

    if (vehicle == null) {
      return Response.notFound((
        body: jsonEncode({'error': 'Vehicle not found'}),
        headers: {'Content-Type': 'application/json'}
      ));
    }

    return Response.ok(jsonEncode(vehicle),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode(({'error': 'Something went wrong: ${e.toString()}'})),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Future<Response> deleteVehicleHandler(Request req) async {
  final id = req.params['id'];

  try {
    var vehicle = await vehicleRepo.getById(id!);

    if (vehicle == null) {
      return Response.notFound((
        body: jsonEncode({'error': 'Vehicle not found'}),
        headers: {'Content-Type': 'application/json'}
      ));
    }
    await vehicleRepo.delete(vehicle.id);

    return Response.ok(jsonEncode(vehicle),
        headers: {'Content-Type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(
      body: jsonEncode(({'error': 'Something went wrong: ${e.toString()}'})),
      headers: {'Content-Type': 'application/json'},
    );
  }
}

Vehicle updateVehicle(Vehicle vehicle, String json) {
  var data = jsonDecode(json) as Map<String, dynamic>;

  if (data['licensePlate'] != null) {
    vehicle.licensePlate = data['licensePlate'];
  }
  if (data['vehicleType'] != null) {
    vehicle.vehicleType =
        VehicleTypeExtension.fromShortString(data['vehicleType']);
  }
  if (data['owner'] != null) {
    vehicle.owner = Person.fromJson(data['owner']);
  }

  return vehicle;
}
