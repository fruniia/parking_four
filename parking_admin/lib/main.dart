import 'package:flutter/material.dart';
import 'package:parking_admin/views/index.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(const ParkingAdmin());
}

class ParkingAdmin extends StatelessWidget {
  const ParkingAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ParkingProvider(
            parkingRepository: ParkingRepository(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ParkingSpaceProvider(
            parkingSpaceRepository: ParkingSpaceRepository(),
          ),
        )
      ],
      child: MaterialApp(
        title: 'Parking app',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
          useMaterial3: true,
        ),
        home: const NavigationView(),
      ),
    );
  }
}
