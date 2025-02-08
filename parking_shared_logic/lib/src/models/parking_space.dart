import 'package:uuid/uuid.dart';

class ParkingSpace {
  String id;
  String address;
  double pricePerHour;

  ParkingSpace(
      {required this.id, required this.address, required this.pricePerHour});
  ParkingSpace.withUUID({required this.address, required this.pricePerHour})
      : id = Uuid().v4();

  factory ParkingSpace.fromJson(Map<String, dynamic> json) {
    return ParkingSpace(
      id: json['id'],
      address: json['address'],
      pricePerHour: double.parse(json['pricePerHour'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'address': address, 'pricePerHour': pricePerHour};
  }
}
