import 'package:flutter/material.dart';
import 'package:fitmanager/presentation/pages/login_page.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 ELIMINAR BASE DE DATOS SOLO UNA VEZ
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'fitmanager.db');
  await deleteDatabase(path);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fit Manager',
      home: const LoginPage(),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:fitmanager/presentation/pages/login_page.dart'; // Cambia si usás otra ruta

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fit Manager',
      home: const LoginPage(), // Aquí va tu pantalla inicial real
    );
  }
}
*/