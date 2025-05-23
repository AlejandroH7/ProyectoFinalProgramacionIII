import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:intl/intl.dart';

class FechasMantenimientoPage extends StatelessWidget {
  const FechasMantenimientoPage({super.key});

  // Datos simulados (solo se mostrarán si la fecha es hoy o futura)
  final List<Map<String, String>> mantenimientos = const [
    {
      'equipo': 'Caminadora 1',
      'fecha': '2024-06-01',
      'descripcion': 'Revisión general y lubricación de motor.',
    },
    {
      'equipo': 'Bicicleta estática',
      'fecha': '2024-05-25',
      'descripcion': 'Cambio de banda de resistencia.',
    },
    {
      'equipo': 'Máquina de remo',
      'fecha': '2024-04-10', // Esta ya pasó y no debería mostrarse
      'descripcion': 'Ajuste de tornillos y revisión de cuerda.',
    },
    {
      'equipo': 'Press de hombros',
      'fecha': '2024-07-12',
      'descripcion': 'Inspección de poleas.',
    },
  ];

  List<Map<String, String>> getMantenimientosPendientes() {
    final now = DateTime.now();
    return mantenimientos.where((m) {
      final fecha = DateTime.tryParse(m['fecha']!);
      return fecha != null &&
          fecha.isAfter(now.subtract(const Duration(days: 1)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final pendientes = getMantenimientosPendientes();

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Row(
          children: [
            const Icon(Icons.calendar_month, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'Fechas de mantenimiento preventivo',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          pendientes.isEmpty
              ? const Center(
                child: Text(
                  'No hay mantenimientos pendientes.',
                  style: TextStyle(color: Colors.white54),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pendientes.length,
                itemBuilder: (context, index) {
                  final item = pendientes[index];
                  return Card(
                    color: const Color(0xFF2A2A2A),
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['equipo']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Fecha programada: ${item['fecha']}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Descripción: ${item['descripcion']}',
                            style: const TextStyle(color: Colors.white70),
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
