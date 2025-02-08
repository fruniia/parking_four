import 'package:flutter/material.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';

class ParkingSpaceProvider extends ChangeNotifier {
  final ParkingSpaceRepository parkingSpaceRepository;
  List<ParkingSpace> _parkingSpaces = [];
  bool _parkingSpacesLoaded = false;

  List<ParkingSpace> get parkingSpaces => _parkingSpaces;

  ParkingSpaceProvider({required this.parkingSpaceRepository});

  Future<void> loadParkingSpaces() async {
    if (_parkingSpaces.isNotEmpty && _parkingSpacesLoaded) {
      return;
    }
    try {
      final parkingSpaces = await parkingSpaceRepository.getAll();
      _parkingSpaces = parkingSpaces;
      _parkingSpacesLoaded = true;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load parking spaces: $e');
    }
  }

  Future<void> createParkingSpace(String address, double pricePerHour) async {
    try {
      final newParkingSpace = ParkingSpace.withUUID(
        address: address,
        pricePerHour: pricePerHour,
      );
      await parkingSpaceRepository.add(newParkingSpace);
      _parkingSpaces.add(newParkingSpace);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to create parking space: $e');
    }
  }

  Future<void> updateParkingSpace(ParkingSpace parkingSpace) async {
    try {
      await parkingSpaceRepository.update(parkingSpace.id, parkingSpace);
      final index = _parkingSpaces.indexWhere((p) => p.id == parkingSpace.id);

      if (index != -1) {
        _parkingSpaces[index] = parkingSpace;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update parking space: $e');
    }
  }

  Future<void> deleteParkingSpace(ParkingSpace parkingSpace) async {
    try {
      await parkingSpaceRepository.delete(parkingSpace.id);
      final index = _parkingSpaces.indexWhere((p) => p.id == parkingSpace.id);

      if (index != -1) {
        _parkingSpaces.remove(parkingSpace);
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to delete parking space: $e');
    }
  }

  Future<void> updateAddressAndPrice(
      ParkingSpace parkingSpace, String newAddress, double newPrice) async {
    parkingSpace.address = newAddress;
    parkingSpace.pricePerHour = newPrice;

    await updateParkingSpace(parkingSpace);
    notifyListeners();
  }
}
