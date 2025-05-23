import 'package:fitmanager/presentation/pages/eliminar_empleado_page.dart';
import 'package:fitmanager/presentation/pages/horarios_turnos_page.dart';
import 'package:fitmanager/presentation/pages/nuevo_empleado_page.dart';
import 'package:fitmanager/presentation/pages/ver_empleados_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GestionEmpleadosPage extends StatelessWidget {
  const GestionEmpleadosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Row(
          children: [
            const Icon(Icons.group, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'Gestión de empleados',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildActionButton(
              icon: Icons.list_alt,
              label: 'Ver empleados',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VerEmpleadosPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              icon: Icons.person_add,
              label: 'Nuevo empleado',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NuevoEmpleadoPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              icon: Icons.person_remove,
              label: 'Eliminar empleado',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EliminarEmpleadoPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildActionButton(
              icon: Icons.schedule,
              label: 'Horarios de turnos',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HorariosTurnosPage()),
                );
              },
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: const Text(
                'Volver',
                style: TextStyle(color: Colors.white),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF9800),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}
