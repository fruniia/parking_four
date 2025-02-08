enum VehicleType{ car, mc, bus, taxi}

extension VehicleTypeExtension on VehicleType {
  String toShortString() {
    return toString().split('.').last;
  }

  static VehicleType fromShortString(String shortString) {
    return VehicleType.values.firstWhere(
      (type) => type.toShortString() == shortString,
      orElse: () => throw Exception('Unknown vehicle type: $shortString'),
    );
  }
}