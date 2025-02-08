import 'package:flutter/material.dart';
import 'package:parking_admin/views/index.dart';

class StartPageView extends StatelessWidget {
  const StartPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Parking admin'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                final navViewState =
                    context.findAncestorStateOfType<NavigationViewState>();
                navViewState?.setSelectedIndex(1);
              },
              child: const Text('Go to Administration page'),
            ),
            TextButton(
              onPressed: () {
                final navViewState =
                    context.findAncestorStateOfType<NavigationViewState>();
                navViewState?.setSelectedIndex(2);
              },
              child: const Text('Go to parking statistics page'),
            )
          ],
        ),
      ),
    );
  }
}
