import 'package:parking_shared_logic/parking_shared_logic.dart';

class ParkingStatisticsService {
  static List<Map<String, dynamic>> getMostPopularParkingSpaces(
      List<Parking> parkingSessions) {
    Map<String, int> addressUsageCount = {};

    for (var parking in parkingSessions) {
      String address = parking.parkingSpace.address;
      if (addressUsageCount.containsKey(address)) {
        addressUsageCount[address] = addressUsageCount[address]! + 1;
      } else {
        addressUsageCount[address] = 1;
      }
    }

    var sortedAddresses = addressUsageCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // List with top 3 addresses
    List<Map<String, dynamic>> topAddresses =
        sortedAddresses.take(3).map((entry) {
      return {
        'address': entry.key,
        'count': entry.value,
      };
    }).toList();

    return topAddresses;
  }
}
