import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'bluetooth.dart';

class BluetoothPage extends StatelessWidget {
  final String token;
  const BluetoothPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    final bluetoothController = Get.put(BluetoothController());

    return Scaffold(
      appBar: AppBar(title: const Text("Bluetooth")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SelectableText(
              "Token recebido: $token",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
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
          Expanded(
            // O StreamBuilder NÃO deve ficar dentro de um Obx!
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
