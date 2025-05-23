import 'package:flutter/material.dart';
import 'package:fitmanager/presentation/pages/login_page.dart'; // Cambia el nombre si usás otro

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
      home: const LoginPage(),
    );
  }
}
