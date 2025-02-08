import 'dart:io';
import 'dart:convert';

import 'package:parking_shared_logic/parking_shared_logic.dart';

class ParkingSpaceDataStore implements InterfaceRepository<ParkingSpace> {
  String filePath = '../parking_server/parkingSpaces.json';

  @override
  Future<List<ParkingSpace>> getAll() async {
    try {
      final file = File(filePath);

      if (!await file.exists()) {
        return [];
      }
      final content = await file.readAsString();
      final List<dynamic> data = jsonDecode(content);

      return data
          .map((parkingSpace) => ParkingSpace.fromJson(parkingSpace))
          .toList();
    } catch (e) {
      print('Error reading file: ${e.toString()}');
      return [];
    }
  }

  @override
  Future<ParkingSpace?> add(ParkingSpace parkingSpace) async {
    final file = File(filePath);
    final List<ParkingSpace> parkingSpaces = await getAll();

    parkingSpaces.add(parkingSpace);

    if (!await file.exists()) {
      await file.create(exclusive: true);
    }

    await file.writeAsString(jsonEncode(parkingSpaces));
    return parkingSpace;
  }

  @override
  Future<ParkingSpace?> update(String id, ParkingSpace newParkingSpace) async {
    final file = File(filePath);

    if (!await file.exists()) {
      await file.create();
    }

    String fileContent = await file.readAsString();

    List<ParkingSpace> parkingSpaces = _getParkingSpaces(fileContent);

    for (var i = 0; i < parkingSpaces.length; i++) {
      if (parkingSpaces[i].id == id) {
        parkingSpaces[i] = newParkingSpace;

        await file.writeAsString(jsonEncode(parkingSpaces
            .map((parkingSpace) => parkingSpace.toJson())
            .toList()));

        return newParkingSpace;
      }
    }
    return null;
  }

  @override
  Future<ParkingSpace?> delete(String id) async {
    final file = File(filePath);

    if (!await file.exists()) {
      await file.create();
    }

    String fileContent = await file.readAsString();
    List<ParkingSpace> parkingSpaces = _getParkingSpaces(fileContent);

    for (var i = 0; i < parkingSpaces.length; i++) {
      if (parkingSpaces[i].id == id) {
        final parkingSpace = parkingSpaces.removeAt(i);

        await file.writeAsString(jsonEncode(parkingSpaces
            .map((parkingSpace) => parkingSpace.toJson())
            .toList()));

        return parkingSpace;
      }
    }
    return null;
  }

  @override
  Future<ParkingSpace?> getById(String id) async {
    final file = File(filePath);
    if (!await file.exists()) {
      await file.create();
    }

    String fileContent = await file.readAsString();
    List<ParkingSpace> parkingSpaces = _getParkingSpaces(fileContent);

    for (var parkingSpace in parkingSpaces) {
      if (parkingSpace.id == id) {
        return parkingSpace;
      }
    }
    return null;
  }

  List<ParkingSpace> _getParkingSpaces(String fileContent) {
    List<ParkingSpace> parkingSpaces = (jsonDecode(fileContent) as List)
        .map((json) => ParkingSpace.fromJson(json))
        .toList();
    return parkingSpaces;
  }
}
