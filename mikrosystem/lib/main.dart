import 'package:flutter/material.dart';
import 'package:mikrosystem/src/auth/Login/login.dart';

void main() {
  // Desactivar la etiqueta Debug
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Login',
      home: Login(),
      debugShowCheckedModeBanner:
          false, // Configuración para quitar la etiqueta "Debug"
    );
  }
}

/*class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Login',
      home: Lista(),
      debugShowCheckedModeBanner:
          false, // Configuración para quitar la etiqueta "Debug"
    );
  }
}*/
