import 'package:flutter/material.dart';

class ParkingSpaceCard extends StatelessWidget {
  final Map<String, dynamic> parkingSpace;
  const ParkingSpaceCard({super.key, required this.parkingSpace});

  @override
  Widget build(BuildContext context) {
    final String address = parkingSpace['address'] ?? 'No address available';
    final int count = parkingSpace['count'] ?? 0;
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        tileColor: Colors.green.shade50,
        title: Text(
          address,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          'Number of parkings: $count',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
        leading: const Icon(Icons.star, color: Colors.green),
      ),
    );
  }
}
