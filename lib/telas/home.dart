import 'package:flutter/material.dart';
import 'dart:async';
import '/bluetooth_page.dart';
import 'carros.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String title = "JornadaAPP";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w700,
              color: Colors.black87),
          bodyLarge: TextStyle(fontSize: 18, color: Color(0xFF6B7280)),
          titleLarge: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87),
        ),
      ),
      home: HomeScreen(),
      routes: {
        '/bluetooth': (_) => BluetoothPage(),
        '/carros': (_) => CarScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isStarted = false;
  late Stopwatch _stopwatch;
  late Timer _timer;
  String _elapsedTime = "00:00:00";

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_stopwatch.isRunning) {
        setState(() {
          _elapsedTime = _formatDuration(_stopwatch.elapsed);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void toggleStartStop() {
    setState(() {
      isStarted = !isStarted;
    });

    if (isStarted) {
      _stopwatch.start();
    } else {
      _stopwatch.stop();
      _showStopOptions();
    }
  }

  void _reset() {
    _stopwatch.reset();
    setState(() {
      _elapsedTime = "00:00:00";
      isStarted = false;
    });
  }

  void _showStopOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Selecione uma opção"),
          content: Text("Tempo decorrido: $_elapsedTime"),
          actions: [
            TextButton(
              child: Text("Parada"),
              onPressed: () {
                Navigator.of(context).pop();
                // Apenas pausa, sem resetar
                setState(() {
                  isStarted = false;
                });
              },
            ),
            TextButton(
              child: Text("Fim do Trajeto"),
              onPressed: () {
                Navigator.of(context).pop();
                _reset();
                // Ação de Fim do Trajeto
              },
            ),
            TextButton(
              child: Text("Continuar"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isStarted = true;
                  _stopwatch.start();
                });
              },
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inHours)}:" "${twoDigits(duration.inMinutes.remainder(60))}:" "${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    final beigeColor = const Color(0xFFF5F0E6);

    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: toggleStartStop,
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(80),
                backgroundColor:
                    isStarted ? Colors.redAccent : Colors.greenAccent,
                foregroundColor: Colors.black87,
                elevation: 6,
                shadowColor: Colors.black26,
                textStyle: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text(isStarted ? 'Stop' : 'Start'),
            ),
            const SizedBox(height: 20),
            Text(
              _elapsedTime,
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 56,
        color: beigeColor,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.directions_car,
                  size: 28, color: Colors.black87),
              onPressed: () {
                Navigator.pushNamed(context, '/carros');
              },
              tooltip: 'Car Page',
            ),
            IconButton(
              icon: const Icon(Icons.bluetooth,
                  size: 28, color: Colors.black87),
              onPressed: () {
                Navigator.pushNamed(context, '/bluetooth');
              },
              tooltip: 'Página Bluetooth',
            ),
          ],
        ),
      ),
    );
  }
}

