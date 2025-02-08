import 'package:flutter/material.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';

class ActiveParkingGrid extends StatelessWidget {
  final ParkingProvider parkingProvider;
  final ParkingCostService _costService;

  const ActiveParkingGrid({
    super.key,
    required this.parkingProvider,
    required ParkingCostService costService,
  }) : _costService = costService;

  @override
  Widget build(BuildContext context) {
    return parkingProvider.activeParkingSessions.isEmpty
        ? const Center(
            child: Text('No active parking sessions',
                style: TextStyle(fontSize: 22)),
          )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 2,
            ),
            itemCount: parkingProvider.activeParkingSessions.length,
            itemBuilder: (context, index) {
              var parking = parkingProvider.activeParkingSessions[index];
              double parkingCost = _costService.calculateParkingCost(parking);

              return Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Parking at ${parking.parkingSpace.address}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'License plate: ${parking.vehicle.licensePlate}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Start date: ${formatDate(parking.start)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Start time: ${formatTime(parking.start)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Cost: ${parkingCost.toStringAsFixed(2)} SEK',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
