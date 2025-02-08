import 'package:flutter/material.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';
import 'package:provider/provider.dart';

class CreateVehicleWidget extends StatefulWidget {
  const CreateVehicleWidget({super.key});
  @override
  State<CreateVehicleWidget> createState() => _CreateVehicleWidgetState();
}

class _CreateVehicleWidgetState extends State<CreateVehicleWidget> {
  final _licensePlateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Person _currentUser;

  VehicleType _selectedVehicleType = VehicleType.car;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    _currentUser = authProvider.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = context.read<VehicleProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Add new vehicle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _licensePlateController,
                decoration:
                    InputDecoration(labelText: 'Add registrationnumber'),
                validator: licensePlateValidator,
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButton<VehicleType>(
                value: _selectedVehicleType,
                isExpanded: true,
                hint: Text("Choose a vehicle type"),
                onChanged: (VehicleType? newValue) {
                  setState(() {
                    _selectedVehicleType = newValue!;
                  });
                },
                items: VehicleType.values.map<DropdownMenuItem<VehicleType>>(
                    (VehicleType vehicleType) {
                  return DropdownMenuItem<VehicleType>(
                    value: vehicleType,
                    child: Text(vehicleType.toShortString()),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await vehicleProvider.createAndAddVehicle(
                        _licensePlateController.text,
                        _currentUser,
                        _selectedVehicleType,
                      );

                      if (mounted) {
                        if (context.mounted) {
                          showCustomSnackBar(context,
                              'Vehicle ${_licensePlateController.text} added',
                              type: 'success');
                          Navigator.pop(context);
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        if (context.mounted) {
                          showCustomSnackBar(
                              context, 'Failed to add vehicle: $e',
                              type: 'error');
                        }
                      }
                    }
                  }
                },
                child: Text('Add vehicle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
