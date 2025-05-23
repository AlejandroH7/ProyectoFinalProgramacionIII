import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistroClientesPage extends StatelessWidget {
  const RegistroClientesPage({super.key});

  // Lista simulada de clientes
  final List<Map<String, String>> clientes = const [
    {
      'codigo': 'CLT-0001',
      'nombre': 'Carlos Pérez',
      'estado': 'Activo',
      'fechaRegistro': '2024-05-01',
    },
    {
      'codigo': 'CLT-0002',
      'nombre': 'María López',
      'estado': 'Inactivo',
      'fechaRegistro': '2024-04-22',
    },
    {
      'codigo': 'CLT-0003',
      'nombre': 'Luis Gómez',
      'estado': 'Activo',
      'fechaRegistro': '2024-05-10',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          'Registro de clientes',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFFF9800),
        onPressed: () {
          // Aquí irá la navegación a filtro por estado
        },
        label: const Text('Filtrar por estado'),
        icon: const Icon(Icons.filter_alt),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: clientes.length,
        itemBuilder: (context, index) {
          final cliente = clientes[index];
          return Card(
            color: const Color(0xFF2A2A2A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    cliente['estado'] == 'Activo' ? Colors.green : Colors.grey,
                child: const Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                cliente['nombre']!,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                'Código: ${cliente['codigo']}\nRegistrado: ${cliente['fechaRegistro']}',
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
              ),
              trailing: Text(
                cliente['estado']!,
                style: TextStyle(
                  color:
                      cliente['estado'] == 'Activo'
                          ? Colors.greenAccent
                          : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                // En el futuro: ver detalle o editar
              },
            ),
          );
        },
      ),
    );
  }
}
