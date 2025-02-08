import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:flutter/material.dart';

class VehicleProvider extends ChangeNotifier {
  final List<Vehicle> _vehicles = [];

  List<Vehicle> get vehicles => _vehicles;

  Future<List<Vehicle>> loadVehicles() async {
    if (_vehicles.isNotEmpty) return _vehicles;

    try {
      _vehicles.clear();
      final vehicles = await VehicleRepository().getAll();
      _vehicles.addAll(vehicles);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load vehicles.');
    }
    return _vehicles;
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      await VehicleRepository().add(vehicle);
      _vehicles.add(vehicle);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add vehicle.');
    }
  }

  Future<void> deleteVehicle(Vehicle vehicle) async {
    try {
      await VehicleRepository().delete(vehicle.id);
      _vehicles.remove(vehicle);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete vehicle.');
    }
  }

  List<Vehicle> vehiclesForUser(String userId) {
    return _vehicles.where((vehicle) {
      return vehicle.owner.id == userId;
    }).toList();
  }

  Future<void> createAndAddVehicle(
      String licensePlate, Person owner, VehicleType vehicleType) async {
    try {
      final newVehicle = Vehicle.withUUID(
        licensePlate: licensePlate,
        owner: owner,
        vehicleType: vehicleType,
      );
      await addVehicle(newVehicle);
    } catch (e) {
      throw Exception('Failed to add vehicle: $e');
    }
  }
}
