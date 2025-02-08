import 'package:flutter/material.dart';
import 'package:parking_admin/views/index.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => NavigationViewState();
}

class NavigationViewState extends State<NavigationView> {
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;

  var options = const <NavigationRailDestination>[
    NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
    NavigationRailDestination(
        icon: Icon(Icons.local_parking), label: Text('Administration')),
    NavigationRailDestination(
        icon: Icon(Icons.access_time), label: Text('Parking statistics')),
  ];

  var pages = const [StartPageView(), AdministrationView(), ParkingView()];

  void setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: labelType,
            destinations: options,
          ),
          const VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          Expanded(child: pages[_selectedIndex])
        ],
      ),
    );
  }
}
