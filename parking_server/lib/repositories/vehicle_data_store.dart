import 'dart:io';
import 'dart:convert';

import 'package:parking_shared_logic/parking_shared_logic.dart';

class VehicleDataStore implements InterfaceRepository<Vehicle> {
  String filePath = '../parking_server/vehicles.json';

  @override
  Future<List<Vehicle>> getAll() async {
    try {
      final file = File(filePath);

      if (!await file.exists()) {
        return [];
      }
      final content = await file.readAsString();
      final List<dynamic> data = jsonDecode(content);
      return data.map((vehicle) => Vehicle.fromJson(vehicle)).toList();
    } catch (e) {
      print('Error reading file: ${e.toString()}');
      return [];
    }
  }

  @override
  Future<Vehicle?> add(Vehicle vehicle) async {
    final file = File(filePath);
    final List<Vehicle> vehicles = await getAll();

    vehicles.add(vehicle);

    if (!await file.exists()) {
      await file.create(exclusive: true);
    }

    await file.writeAsString(jsonEncode(vehicles));
    return vehicle;
  }

  @override
  Future<Vehicle?> update(String id, Vehicle newItem) async {
    final file = File(filePath);

    if (!await file.exists()) {
      await file.create();
    }

    String fileContent = await file.readAsString();

    List<Vehicle> vehicles = _getVehicles(fileContent);

    for (var i = 0; i < vehicles.length; i++) {
      if (vehicles[i].id == id) {
        vehicles[i] = newItem;

        await file.writeAsString(
            jsonEncode(vehicles.map((vehicle) => vehicle.toJson()).toList()));

        return newItem;
      }
    }
    return null;
  }

  @override
  Future<Vehicle?> delete(String id) async {
        final file = File(filePath);

    if (!await file.exists()) {
      await file.create();
    }

    String fileContent = await file.readAsString();
    List<Vehicle> vehicles = _getVehicles(fileContent);

    for (var i = 0; i < vehicles.length; i++) {
      if (vehicles[i].id == id) {
        final vehicle = vehicles.removeAt(i);

        await file.writeAsString(
            jsonEncode(vehicles.map((vehicle) => vehicle.toJson()).toList()));

        return vehicle;
      }
    }
    return null;
  }

  @override
  Future<Vehicle?> getById(String id) async {
    final file = File(filePath);
    if (!await file.exists()) {
      await file.create();
    }

    String fileContent = await file.readAsString();
    List<Vehicle> vehicles = _getVehicles(fileContent);

    for (var vehicle in vehicles) {
      if (vehicle.id == id) {
        return vehicle;
      }
    }
    return null;
  }

  List<Vehicle> _getVehicles(String fileContent) {
    List<Vehicle> vehicles = (jsonDecode(fileContent) as List)
        .map((json) => Vehicle.fromJson(json))
        .toList();
    return vehicles;
  }
}
