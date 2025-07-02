import 'package:flutter/material.dart';

class BluetoothScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Page'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Text(
          'This is the Bluetooth page.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}