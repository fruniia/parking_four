import 'package:flutter/material.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';
import 'package:parking_user/widgets/index.dart';
import 'package:provider/provider.dart';

class ParkVehicleWidget extends StatefulWidget {
  const ParkVehicleWidget({super.key});

  @override
  State<ParkVehicleWidget> createState() => _ParkVehicleWidgetState();
}

class _ParkVehicleWidgetState extends State<ParkVehicleWidget> {
  final _formKey = GlobalKey<FormState>();
  Vehicle? _selectedVehicle;
  ParkingSpace? _selectedParkingSpace;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final parkingSpaceProvider = context.read<ParkingSpaceProvider>();
    final parkingProvider = context.read<ParkingProvider>();

    if (parkingSpaceProvider.parkingSpaces.isEmpty) {
      parkingSpaceProvider.loadParkingSpaces();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Park Vehicle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<VehicleProvider>(
            builder: (context, vehicleProvider, child) {
          final userId = authProvider.currentUser?.id;
          final vehicles = vehicleProvider.vehiclesForUser(userId ?? '');

          if (vehicles.isEmpty) {
            return Column(
              children: [
                Center(child: Text('You have not registered a vehicle.')),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateVehicleWidget(),
                      ),
                    );
                  },
                  child: const Text(
                    'Please register a vehicle',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            );
          }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                Consumer<ParkingSpaceProvider>(
                  builder: (context, parkingSpaceService, child) {
                    final parkingSpaces = parkingSpaceService.parkingSpaces;
                    if (parkingSpaces.isEmpty) {
                      return Text('No parking spaces available');
                    }

                    if (_selectedParkingSpace == null &&
                        parkingSpaces.isNotEmpty) {
                      _selectedParkingSpace = parkingSpaces.first;
                    }

                    return DropdownButton<ParkingSpace>(
                      value: _selectedParkingSpace,
                      isExpanded: true,
                      hint: Text("Choose a parking space"),
                      onChanged: (ParkingSpace? newValue) {
                        setState(() {
                          _selectedParkingSpace = newValue!;
                        });
                      },
                      items: parkingSpaces.map<DropdownMenuItem<ParkingSpace>>(
                        (ParkingSpace parkingSpace) {
                          return DropdownMenuItem<ParkingSpace>(
                            value: parkingSpace,
                            child: Text(parkingSpace.address),
                          );
                        },
                      ).toList(),
                    );
                  },
                ),
                const SizedBox(height: 20),
                DropdownButton<Vehicle>(
                  value: _selectedVehicle,
                  isExpanded: true,
                  hint: Text("Choose a vehicle to park"),
                  onChanged: (Vehicle? newValue) {
                    setState(() {
                      _selectedVehicle = newValue!;
                    });
                  },
                  items: vehicles.map<DropdownMenuItem<Vehicle>>(
                    (Vehicle vehicle) {
                      return DropdownMenuItem<Vehicle>(
                        value: vehicle,
                        child: Text(vehicle.licensePlate),
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final currentUser = authProvider.currentUser;
                    if (_formKey.currentState!.validate()) {
                      if (currentUser == null) {
                        showCustomSnackBar(
                            context, 'Please log in to park a vehicle',
                            type: 'error');
                      }
                      try {
                        await parkingProvider.startParkingSession(
                            _selectedVehicle!,
                            _selectedParkingSpace!,
                            authProvider);

                        if (context.mounted) {
                          showCustomSnackBar(
                            context,
                            'Vehicle ${_selectedVehicle!.licensePlate} parked at ${_selectedParkingSpace!.address}',
                            type: 'success',
                          );
                          Navigator.pop(context, true);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          showCustomSnackBar(
                            context,
                            'Failed to park vehicle: ${e.toString()}',
                            type: 'error',
                          );
                        }
                      }
                    } else {
                      showCustomSnackBar(
                        context,
                        'Please select both a parking spot and a vehicle',
                        type: 'error',
                      );
                    }
                  },
                  child: Text('Park Vehicle'),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
