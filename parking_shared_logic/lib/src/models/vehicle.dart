import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:uuid/uuid.dart';

class Vehicle {
  String id;
  String licensePlate;
  Person owner;
  VehicleType vehicleType;

  Vehicle(
      {required this.id,
      required this.licensePlate,
      required this.owner,
      required this.vehicleType});

  Vehicle.withUUID({
    required this.licensePlate,
    required this.owner,
    required this.vehicleType,
  }) : id = Uuid().v4();

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
        id: json['id'],
        licensePlate: json['licensePlate'],
        owner: Person.fromJson(json['owner']),
        vehicleType: VehicleTypeExtension.fromShortString(json['vehicleType']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'licensePlate': licensePlate,
      'owner': owner.toJson(),
      'vehicleType': vehicleType.toShortString(),
    };
  }
}
