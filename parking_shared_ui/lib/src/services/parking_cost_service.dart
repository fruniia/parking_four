import 'package:parking_shared_logic/parking_shared_logic.dart';

class ParkingCostService {
  double calculateParkingCost(Parking parking) {
    DateTime stopTime = parking.stop ?? DateTime.now();
    Duration duration = stopTime.difference(parking.start);
    double hours = duration.inMinutes / 60.0;
    return hours * parking.parkingSpace.pricePerHour;
  }

  double calculateTotalEarning(
      List<Parking> activeParkings, List<Parking> completedParkings) {
    double totalCost = 0.0;
    for (var parking in activeParkings) {
      totalCost += calculateParkingCost(parking);
    }

    for (var parking in completedParkings) {
      totalCost += calculateParkingCost(parking);
    }
    return totalCost;
  }
}
