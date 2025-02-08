import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:uuid/uuid.dart';

class Parking {
  String id;
  Vehicle vehicle;
  ParkingSpace parkingSpace;
  DateTime _start = DateTime.now().toUtc();
  DateTime? _stop;

  void updateStart(DateTime newStart) {
    _start = newStart.toUtc();
  }

  void updateStop(DateTime? newStop) {
    if (newStop != null) {
      _stop = newStop.toUtc();
    } else {
      _stop = null;
    }
  }

  DateTime get start => _start;
  DateTime? get stop => _stop;

  Parking(
      {required this.id, required this.vehicle, required this.parkingSpace});

  Parking.withUUID({
    required this.vehicle,
    required this.parkingSpace,
  }) : id = Uuid().v4();

  factory Parking.fromJson(Map<String, dynamic> json) {
    var parking = Parking(
      id: json['id'],
      vehicle: Vehicle.fromJson(json['vehicle']),
      parkingSpace: ParkingSpace.fromJson(json['parkingSpace']),
    );

    parking.updateStart(DateTime.parse(json['start']).toUtc());

    if (json['stop'] != null) {
      parking.updateStop(DateTime.parse(json['stop']).toUtc());
    }
    return parking;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'id': id,
      'vehicle': vehicle.toJson(),
      'parkingSpace': parkingSpace.toJson(),
      'start': _start.toIso8601String(),
    };

    if (_stop != null) {
      json['stop'] = _stop?.toIso8601String();
    }
    return json;
  }
}
