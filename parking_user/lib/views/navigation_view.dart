import 'package:flutter/material.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';
import 'package:parking_user/main.dart';
import 'package:parking_user/views/index.dart';
import 'package:provider/provider.dart';

class NavigationView extends StatelessWidget {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavigationProvider(),
      child: Consumer<NavigationProvider>(
          builder: (context, navigationService, _) {
        return Scaffold(
          body: _getCurrentPage(navigationService.currentIndex),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navigationService.currentIndex,
            onTap: (index) async {
              if (index == 3) {
                _showLogoutConfirmationDialog(context);
              } else {
                navigationService.currentIndex = index;
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.location_on), label: 'My Parkings'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.directions_car), label: 'My Vehicles'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.logout), label: 'Logout'),
            ],
            backgroundColor: Colors.deepPurple,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.blueGrey,
          ),
        );
      }),
    );
  }

  Widget _getCurrentPage(int index) {
    const pages = [
      UserView(),
      ParkingView(),
      VehicleView(),
    ];
    return pages[index];
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlertDialog(
            title: 'Confirm logout?',
            message: 'Do you really want to logout?',
            cancelText: 'Cancel',
            confirmText: 'Confirm',
            onCancel: () {
              Navigator.pop(context);
            },
            onConfirm: () {
              Navigator.pop(context);
              context.read<AuthProvider>().logout();
              context.read<ParkingProvider>().clearData();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginViewSwitch()),
              );
            });
      },
    );
  }
}
