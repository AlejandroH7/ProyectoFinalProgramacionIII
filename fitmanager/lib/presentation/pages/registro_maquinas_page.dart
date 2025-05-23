import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistroMaquinasPage extends StatelessWidget {
  const RegistroMaquinasPage({super.key});

  // Datos simulados
  final List<Map<String, String>> maquinas = const [
    {
      'nombre': 'Bicicleta estática',
      'cantidad': '3',
      'descripcion': 'Para entrenamiento cardiovascular de baja intensidad.',
      'fecha': '2024-05-01',
    },
    {
      'nombre': 'Máquina de remo',
      'cantidad': '2',
      'descripcion': 'Fortalece espalda, brazos y piernas.',
      'fecha': '2024-05-03',
    },
    {
      'nombre': 'Press de pecho',
      'cantidad': '4',
      'descripcion': 'Entrena pectorales y tríceps.',
      'fecha': '2024-05-10',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Row(
          children: [
            const Icon(Icons.list_alt, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'Registro de máquinas y equipos',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: maquinas.length,
        itemBuilder: (context, index) {
          final item = maquinas[index];
          return Card(
            color: const Color(0xFF2A2A2A),
            margin: const EdgeInsets.only(bottom: 14),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['nombre']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Cantidad: ${item['cantidad']}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Descripción: ${item['descripcion']}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Fecha de registro: ${item['fecha']}',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
