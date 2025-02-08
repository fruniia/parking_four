import 'package:flutter/material.dart';
import 'package:parking_admin/utils/index.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';
import 'package:provider/provider.dart';

class CreateParkingSpaceWidget extends StatefulWidget {
  const CreateParkingSpaceWidget({super.key});

  @override
  State<CreateParkingSpaceWidget> createState() =>
      _CreateParkingSpaceWidgetState();
}

class _CreateParkingSpaceWidgetState extends State<CreateParkingSpaceWidget> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController addressController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new parking space'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formkey,
          child: ListView(padding: const EdgeInsets.symmetric(vertical: 10.0), children: [
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                hintText: 'Address',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              validator: validateAddress,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(
                hintText: 'Price per hour',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(),
              validator: validatePrice,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton(onPressed: _saveData, child: const Text('Save')),
            )
          ]),
        ),
      ),
    );
  }

  void _saveData() async {
    if (_formkey.currentState?.validate() ?? false) {
      final address = addressController.text;
      final pricePerHour = double.tryParse(priceController.text);

      try {
        await context
            .read<ParkingSpaceProvider>()
            .createParkingSpace(address, pricePerHour!);

        if (mounted) {
          showCustomSnackBar(context,
              'Parkingspace $address, $pricePerHour created',
              type: 'success');
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          showCustomSnackBar(context, 'Failed to create parking space: $e',
              type: 'error');
        }
      }
    } else {
      showCustomSnackBar(context, 'Please correct the highligthed fields',
          type: 'error');
    }
  }
}
