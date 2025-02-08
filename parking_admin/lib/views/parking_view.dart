import 'package:flutter/material.dart';
import 'package:parking_admin/widgets/index.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';
import 'package:provider/provider.dart';

class ParkingView extends StatefulWidget {
  const ParkingView({super.key});

  @override
  State<StatefulWidget> createState() => _ParkingViewState();
}

class _ParkingViewState extends State<ParkingView> {
  final ParkingCostService costService = ParkingCostService();
  @override
  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() async {
    try {
      final parkingProvider = context.read<ParkingProvider>();
      final parkingSpaceProvider = context.read<ParkingSpaceProvider>();
      // Admin does not have a login
      // Hardcoded: isAdmin = true and authProvider = null
      parkingProvider.isAdmin = true;
      await parkingSpaceProvider.loadParkingSpaces();
      await parkingProvider.loadActiveParkingSessions(null);
      await parkingProvider.loadCompletedParkingSessions(null);
    } catch (e) {
      if (mounted) {
        showCustomSnackBar(context, 'Failed to load data: $e', type: 'error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ParkingProvider>(
        builder: (context, parkingProvider, child) {
      if (parkingProvider.activeParkingSessions.isEmpty &&
          parkingProvider.completedParkingSessions.isEmpty) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Active parking sessions'),
          ),
          body: const Center(
            child: Text(
              'No active parking sessions.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
        );
      }

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Active parking sessions'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Top 3 Most Popular Parking Spaces',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  parkingProvider.mostPopularParkingSpaces.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'No popular parking spaces found',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : Column(
                          children: parkingProvider.mostPopularParkingSpaces
                              .map<Widget>((data) =>
                                  ParkingSpaceCard(parkingSpace: data))
                              .toList(),
                        )
                ],
              ),
              const SizedBox(height: 20),
              const Text('Active parking sessions',
                  style: TextStyle(fontSize: 22)),
              const SizedBox(height: 10),
              Expanded(
                  child: ActiveParkingGrid(
                      parkingProvider: parkingProvider,
                      costService: costService)),
              const SizedBox(height: 10),
              const Text(
                'Statistics',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                  'Number of active parking sessions: ${parkingProvider.activeParkingSessions.length}'),
              const SizedBox(height: 10),
              Text(
                'Overall total earning: ${costService.calculateTotalEarning(parkingProvider.activeParkingSessions, parkingProvider.completedParkingSessions).toStringAsFixed(2)} SEK',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    });
  }
}
