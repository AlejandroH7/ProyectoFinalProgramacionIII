import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerEmpleadosPage extends StatelessWidget {
  const VerEmpleadosPage({super.key});

  // Lista simulada de empleados
  final List<Map<String, String>> empleados = const [
    {'nombre': 'Ana Ramírez', 'id': 'EMP-001', 'cargo': 'Recepcionista'},
    {'nombre': 'Luis Herrera', 'id': 'EMP-002', 'cargo': 'Instructor de pesas'},
    {
      'nombre': 'Carlos Méndez',
      'id': 'EMP-003',
      'cargo': 'Entrenador personal',
    },
    {'nombre': 'María Velásquez', 'id': 'EMP-004', 'cargo': 'Nutricionista'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          'Lista de empleados',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: empleados.length,
                itemBuilder: (context, index) {
                  final empleado = empleados[index];
                  return Card(
                    color: const Color(0xFF2A2A2A),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.orange),
                      title: Text(
                        empleado['nombre']!,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'ID: ${empleado['id']}\nCargo: ${empleado['cargo']}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: const Text(
                'Volver',
                style: TextStyle(color: Colors.white),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
