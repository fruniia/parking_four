import 'package:flutter/material.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';
import 'package:provider/provider.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:parking_user/views/index.dart';

void main() {
  runApp(MultiProvider(providers: [
    Provider<ParkingRepository>(create: (_) => ParkingRepository()),
    Provider<ParkingSpaceRepository>(create: (_) => ParkingSpaceRepository()),
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => VehicleProvider()),
    ChangeNotifierProvider(
      create: (context) => ParkingSpaceProvider(
          parkingSpaceRepository: context.read<ParkingSpaceRepository>()),
    ),
    ChangeNotifierProvider<ParkingProvider>(create: (context) {
      return ParkingProvider(
          parkingRepository: context.read<ParkingRepository>());
    })
  ], child: const ParkingUser()));
}

class ParkingUser extends StatelessWidget {
  const ParkingUser({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginViewSwitch(),
    );
  }
}

class LoginViewSwitch extends StatelessWidget {
  const LoginViewSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn =
        context.watch<AuthProvider>().status == UserAuthStatus.authenticated;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeOut,
        child: isLoggedIn ? NavigationView() : LoginView(),
      ),
    );
  }
}
