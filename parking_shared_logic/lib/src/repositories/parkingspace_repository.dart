import 'dart:io';

import 'package:parking_shared_logic/parking_shared_logic.dart';

class ParkingSpaceRepository implements InterfaceRepository<ParkingSpace> {
    final String baseUrl = Platform.isAndroid
      ? "http://10.0.2.2:8080/parkingSpaces"
      : "http://localhost:8080/parkingSpaces";

  @override
  Future<ParkingSpace?> add(ParkingSpace parkingSpace) async {
    try {
      return await fetchData<ParkingSpace>(
        url: baseUrl,
        method: 'POST',
        body: parkingSpace.toJson(),
        fromJson: (data) => ParkingSpace.fromJson(data),
      );
    } catch (e) {
      throw Exception('Failed to add parkingspace: $e');
    }
  }

  @override
  Future<ParkingSpace?> delete(String id) async {
    try {
      return await fetchData<ParkingSpace>(
        url: '$baseUrl/$id',
        method: 'DELETE',
        fromJson: (data) => ParkingSpace.fromJson(data),
      );
    } catch (e) {
      throw Exception('Failed to delete parkingspace: $e');
    }
  }

  @override
  Future<List<ParkingSpace>> getAll() async {
    try {
      return await fetchData<List<ParkingSpace>>(
        url: baseUrl,
        method: 'GET',
        fromJson: (data) {
          return (data as List)
              .map((parkingSpace) => ParkingSpace.fromJson(parkingSpace))
              .toList();
        },
      );
    } catch (e) {
      throw Exception('Failed to fetch parkingspaces: $e');
    }
  }

  @override
  Future<ParkingSpace?> getById(String id) async {
    try {
      return await fetchData<ParkingSpace>(
        url: '$baseUrl/$id',
        method: 'GET',
        fromJson: (data) => ParkingSpace.fromJson(data),
      );
    } catch (e) {
      throw Exception('Failed to get parkingspace: $e');
    }
  }

  @override
  Future<ParkingSpace?> update(String id, ParkingSpace newItem) async {
    try {
      return await fetchData<ParkingSpace>(
        url: '$baseUrl/$id',
        method: 'PUT',
        body: newItem.toJson(),
        fromJson: (data) => ParkingSpace.fromJson(data),
      );
    } catch (e) {
      throw Exception('Failed to update parkingspace: $e');
    }
  }
}
