import 'package:flutter/material.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';
import 'package:provider/provider.dart';

class DeleteParkingSpaceWidget extends StatefulWidget {
  final ParkingSpace parkingSpace;

  const DeleteParkingSpaceWidget({super.key, required this.parkingSpace});
  @override
  State<StatefulWidget> createState() => _DeleteParkingSpaceWidgetState();
}

class _DeleteParkingSpaceWidgetState extends State<DeleteParkingSpaceWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final parkingSpace = widget.parkingSpace;
    return CustomAlertDialog(
        title: 'Are you sure you want to delete?',
        message: parkingSpace.address,
        cancelText: 'Cancel',
        confirmText: 'Confirm',
        onCancel: () {
          Navigator.pop(context);
        },
        onConfirm: () async {
          try {
            await context
                .read<ParkingSpaceProvider>()
                .deleteParkingSpace(parkingSpace);

            if (context.mounted) {
              showCustomSnackBar(
                  context, '${parkingSpace.address} deleted successfully',
                  type: 'success');

              Navigator.pop(context, parkingSpace);
            }
          } catch (e) {
            if (context.mounted) {
              showCustomSnackBar(context, 'Failed to delete parking space: $e',
                  type: 'error');
            }
          }
        });
  }
}
