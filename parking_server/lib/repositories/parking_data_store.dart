import 'dart:io';
import 'dart:convert';

import 'package:parking_shared_logic/parking_shared_logic.dart';

class ParkingDataStore implements InterfaceRepository<Parking>{
  String filePath = '../parking_server/parkings.json';

  @override
  Future<List<Parking>> getAll() async{
        try {
      final file = File(filePath);

      if (!await file.exists()) {
        return [];
      }
      final content = await file.readAsString();
      final List<dynamic> data = jsonDecode(content);
      return data
          .map((parking) => Parking.fromJson(parking))
          .toList();
    } catch (e) {
      print('Error reading file: ${e.toString()}');
      return [];
    }
  }

  @override
  Future<Parking?> add(Parking parking) async{
    final file = File(filePath);
    final List<Parking> parkings = await getAll();


    if (!await file.exists()) {
      await file.create(exclusive: true);
    }
    parkings.add(parking);

    await file.writeAsString(jsonEncode(parkings));
    return parking;
  }

  @override
  Future<Parking?> delete(String id) async{
        final file = File(filePath);

    if (!await file.exists()) {
      await file.create();
    }

    String fileContent = await file.readAsString();
    List<Parking> parkings = _getParkings(fileContent);

    for (var i = 0; i < parkings.length; i++) {
      if (parkings[i].id == id) {
        final parking = parkings.removeAt(i);

        await file.writeAsString(jsonEncode(parkings
            .map((p) => p.toJson())
            .toList()));

        return parking;
      }
    }
    return null;
  }


  @override
  Future<Parking?> getById(String id) async{
       final file = File(filePath);
    if (!await file.exists()) {
      await file.create();
    }

    String fileContent = await file.readAsString();
    List<Parking> parkings = _getParkings(fileContent);

    for (var parking in parkings) {
      if (parking.id == id) {
        return parking;
      }
    }
    return null;
  }

  @override
  Future<Parking?> update(String id, Parking newParking) async{
        final file = File(filePath);

    if (!await file.exists()) {
      await file.create();
    }

    String fileContent = await file.readAsString();

    List<Parking> parkings = _getParkings(fileContent);

    for (var i = 0; i < parkings.length; i++) {
      if (parkings[i].id == id) {
        parkings[i] = newParking;

        await file.writeAsString(jsonEncode(
            parkings.map((parking) => parking.toJson()).toList()));

        return newParking;
      }
    }
    return null;
  }

    List<Parking> _getParkings(String fileContent) {
    List<Parking> parkings = (jsonDecode(fileContent) as List)
        .map((json) => Parking.fromJson(json))
        .toList();
    return parkings;
  }
}