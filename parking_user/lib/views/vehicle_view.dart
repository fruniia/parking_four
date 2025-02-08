import 'package:flutter/material.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';
import 'package:provider/provider.dart';
import 'package:parking_user/widgets/index.dart';

class VehicleView extends StatefulWidget {
  const VehicleView({super.key});

  @override
  VehicleViewState createState() => VehicleViewState();
}

class VehicleViewState extends State<VehicleView> {
  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    final vehicleProvider = context.watch<VehicleProvider>();

    try {
      await vehicleProvider.loadVehicles();
    } catch (e) {
      if (mounted) {
        showCustomSnackBar(context, e.toString(), type: 'error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.currentUser == null) {
      return Scaffold(
        body: Center(child: Text('You need to login')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${authProvider.currentUser!.name}s vehicles',
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
        backgroundColor: Colors.lightBlueAccent.shade400,
        foregroundColor: Colors.white,
      ),
      body: Consumer<VehicleProvider>(
        builder: (context, vehicleProvider, child) {
          final vehiclesForCurrentUser =
              vehicleProvider.vehiclesForUser(authProvider.currentUser!.id);

          if (vehiclesForCurrentUser.isEmpty) {
            return Center(child: Text('No vehicles registered for this user.'));
          }

          return ListView.builder(
            itemCount: vehiclesForCurrentUser.length,
            itemBuilder: (context, index) {
              final vehicle = vehiclesForCurrentUser[index];
              return ListTile(
                title: Text(vehicle.licensePlate),
                subtitle: Text(vehicle.vehicleType.toShortString()),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    try {
                      await vehicleProvider.deleteVehicle(vehicle);
                      if (context.mounted) {
                        showCustomSnackBar(context, 'Vehicle is removed',
                            type: 'success');
                      }
                    } catch (e) {
                      if (context.mounted) {
                        showCustomSnackBar(context, e.toString(),
                            type: 'error');
                      }
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateVehicleWidget(),
              ),
            );
          },
          backgroundColor: Colors.lightBlue.shade200,
          icon: Icon(Icons.add),
          label: Text(
            'Add vehicle',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
