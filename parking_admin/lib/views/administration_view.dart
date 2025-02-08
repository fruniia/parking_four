import 'package:flutter/material.dart';
import 'package:parking_admin/widgets/index.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';
import 'package:provider/provider.dart';

class AdministrationView extends StatefulWidget {
  const AdministrationView({super.key});

  @override
  AdministrationViewState createState() => AdministrationViewState();
}

class AdministrationViewState extends State<AdministrationView> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _loadParkingSpaces();
  }

  Future<void> _loadParkingSpaces() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final parkingSpaceProvider = context.read<ParkingSpaceProvider>();
      await parkingSpaceProvider.loadParkingSpaces();
    } catch (e) {
      if (mounted) {
        showCustomSnackBar(context, 'Failed to load parking spaces: $e',
            type: 'error');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Manage parking spaces'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'List of parking spaces',
              style: TextStyle(
                fontSize: 26,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: Consumer<ParkingSpaceProvider>(
                          builder: (context, parkingSpaceProvider, child) {
                        if (parkingSpaceProvider.parkingSpaces.isEmpty) {
                          return const Center(
                            child: Text(
                              'No parking spaces available.',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount:
                                parkingSpaceProvider.parkingSpaces.length,
                            itemBuilder: (context, index) {
                              return ParkingSpaceWidget(
                                  parkingSpace:
                                      parkingSpaceProvider.parkingSpaces[index],
                                  index: index,
                                  onDelete: (ParkingSpace parkingSpace) {
                                    parkingSpaceProvider.deleteParkingSpace(
                                        parkingSpaceProvider
                                            .parkingSpaces[index]);
                                  });
                            },
                          );
                        }
                      }),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Center(
        child: FloatingActionButton.extended(
          onPressed: () {
            navigateToCreateView(context);
          },
          label: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Add new parking space'),
              Icon(Icons.add),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToCreateView(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateParkingSpaceWidget()),
    );
    if (result == true) {
      if (context.mounted) {
        _loadParkingSpaces();
      }
    }
  }
}
