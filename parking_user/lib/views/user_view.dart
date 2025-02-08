import 'package:flutter/material.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';
import 'package:provider/provider.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      if (authProvider.currentUser == null) {
        return Scaffold(
            body: Center(
          child: Text("You need to login!"),
        ));
      }
      return Scaffold(
        appBar: AppBar(
          title: Text(
            '${authProvider.currentUser?.name}s page',
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
          backgroundColor: Colors.lightBlueAccent.shade400,
          foregroundColor: Colors.white,
        ),
        body: Center(
            child: Text(
          'Welcome\n${authProvider.currentUser?.name}!',
          style: TextStyle(fontSize: 32),
          textAlign: TextAlign.center,
          softWrap: true,
        )),
      );
    });
  }
}
