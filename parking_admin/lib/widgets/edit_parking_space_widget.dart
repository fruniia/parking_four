import 'package:flutter/material.dart';
import 'package:parking_admin/utils/index.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';
import 'package:provider/provider.dart';

class EditParkingSpaceWidget extends StatefulWidget {
  final ParkingSpace parkingSpace;

  const EditParkingSpaceWidget({super.key, required this.parkingSpace});
  @override
  State<StatefulWidget> createState() => _EditParkingSpaceWidgetState();
}

class _EditParkingSpaceWidgetState extends State<EditParkingSpaceWidget> {
  final _formkey = GlobalKey<FormState>();
  late TextEditingController addressController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    addressController =
        TextEditingController(text: widget.parkingSpace.address);
    priceController = TextEditingController(
        text: widget.parkingSpace.pricePerHour.toString());
  }

  @override
  void dispose() {
    addressController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    if (_formkey.currentState?.validate() ?? false) {
      final newAdddress = addressController.text;
      final newPrice = double.tryParse(
          priceController.text) ?? widget.parkingSpace.pricePerHour;

      try {
        await context
            .read<ParkingSpaceProvider>()
            .updateAddressAndPrice(widget.parkingSpace, newAdddress, newPrice);

        if (mounted) {
          showCustomSnackBar(context,
              'Parking space updated successfully',
              type: 'success');
          Navigator.pop(context, widget.parkingSpace);
        }
      } catch (e) {
        if (mounted) {
          showCustomSnackBar(context, 'Failed to update parking space: $e',
              type: 'error');
        }
      }
    } else {
      showCustomSnackBar(context, 'Please fix the errors in the form',
          type: 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: validateAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price per hour',
                  border: OutlineInputBorder(),
                ),
                validator: validatePrice,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('Save changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
