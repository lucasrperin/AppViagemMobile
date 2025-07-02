import 'package:flutter/material.dart';

class CarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Page'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Text(
          'This is the Car page.',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
