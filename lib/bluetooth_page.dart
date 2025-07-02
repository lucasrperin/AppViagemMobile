import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'bluetooth.dart'; // seu controlador
import 'telas/home.dart';

class BluetoothPage extends StatelessWidget {
  const BluetoothPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bluetoothController = Get.put(BluetoothController());

    return Scaffold(
      appBar: AppBar(title: const Text("Bluetooth")),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Obx(
            () => ElevatedButton(
              onPressed: bluetoothController.isScanning.value
                  ? null
                  : bluetoothController.scanDevices,
              child: bluetoothController.isScanning.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Escanear dispositivos"),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Get.to(() => const Home());
            },
            child: const Text("Ir para Home"),
          ),
          Expanded(
            child: StreamBuilder<List<ScanResult>>(
              stream: bluetoothController.scanResults,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Nenhum dispositivo encontrado.'),
                  );
                }
                final results = snapshot.data!;
                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final result = results[index];
                    return ListTile(
                      title: Text(result.device.advName),
                      subtitle: Text(result.device.remoteId.str),
                      onTap: () {
                        bluetoothController.connectToDevice(result.device);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
