import 'package:fitmanager/presentation/pages/fecha_mantenimiento_page.dart';
import 'package:fitmanager/presentation/pages/fechas_mantenimiento_page.dart';
import 'package:fitmanager/presentation/pages/nueva_maquina_page.dart';
import 'package:fitmanager/presentation/pages/registro_maquinas_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InventarioMantenimientoPage extends StatefulWidget {
  const InventarioMantenimientoPage({super.key});

  @override
  State<InventarioMantenimientoPage> createState() =>
      _InventarioMantenimientoPageState();
}

class _InventarioMantenimientoPageState
    extends State<InventarioMantenimientoPage> {
  String? opcionSeleccionada;

  void _navegarSegunOpcion(String? opcion) {
    if (opcion == null) return;

    setState(() => opcionSeleccionada = opcion);

    switch (opcion) {
      case 'Nueva máquina o equipo':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NuevaMaquinaPage()),
        );
        break;
      case 'Nueva fecha de mantenimiento':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FechaMantenimientoPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Row(
          children: [
            const Icon(Icons.build, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'Inventario de equipos y mantenimiento',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              dropdownColor: const Color(0xFF2A2A2A),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: 'Registrar...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              value: opcionSeleccionada,
              items: const [
                DropdownMenuItem(
                  value: 'Nueva máquina o equipo',
                  child: Text('Nueva máquina o equipo'),
                ),
                DropdownMenuItem(
                  value: 'Nueva fecha de mantenimiento',
                  child: Text('Nueva fecha de mantenimiento'),
                ),
              ],
              onChanged: _navegarSegunOpcion,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegistroMaquinasPage(),
                  ),
                );
              },
              icon: const Icon(Icons.list, color: Colors.white),
              label: const Text(
                'Registro de máquinas y equipos',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navegar a pantalla de fechas de mantenimiento
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FechasMantenimientoPage(),
                  ),
                );
              },
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              label: const Text(
                'Fechas de mantenimiento preventivo',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
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
