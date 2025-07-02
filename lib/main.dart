import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'login.dart';
import 'telas/carros.dart';
import 'bluetooth_page.dart';
import 'telas/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JornadaAPP',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: LoginScreen(),
      routes: { //rotas que direcionam para as telas da aplicação
        '/carros': (context) => CarScreen(),
        '/bluetooth' : (context) => BluetoothPage(),
      },
    );
  }
}