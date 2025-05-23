import 'package:fitmanager/presentation/pages/nuevo_cliente_page.dart';
import 'package:fitmanager/presentation/pages/registro_clientes_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final TextEditingController _searchController = TextEditingController();
  String estadoSeleccionado = 'Todos';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          'Gestión de clientes',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Búsqueda
            Text(
              'Buscar cliente',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Ingrese nombre o código',
                hintStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.grey[300],
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 🧾 Acciones
            Text(
              'Acciones rápidas',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 12),
            _buildMainButton(
              icon: Icons.person_add,
              text: 'Nuevo cliente',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NuevoClientePage()),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildMainButton(
              icon: Icons.list,
              text: 'Registro de clientes',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegistroClientesPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),

            // 🔄 Filtro
            Text(
              'Filtrar por estado',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 8),
            _buildDropdown(),
            const SizedBox(height: 10),

            // Placeholder de resumen
            if (estadoSeleccionado != 'Todos')
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Mostrando: clientes $estadoSeleccionado'.toLowerCase(),
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ),

            const SizedBox(height: 40),

            // ↩️ Volver
            Center(
              child: _buildSecondaryButton(
                icon: Icons.arrow_back,
                text: 'Volver',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF9800),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildSecondaryButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        side: const BorderSide(color: Colors.white),
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: estadoSeleccionado,
      dropdownColor: const Color.fromARGB(
        255,
        192,
        190,
        190,
      ), // fondo gris claro
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      ),
      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      items: const [
        DropdownMenuItem(value: 'Todos', child: Text('Todos')),
        DropdownMenuItem(value: 'Activos', child: Text('Clientes activos')),
        DropdownMenuItem(value: 'Inactivos', child: Text('Clientes inactivos')),
      ],
      onChanged: (value) {
        setState(() {
          estadoSeleccionado = value!;
        });
      },
    );
  }
}
