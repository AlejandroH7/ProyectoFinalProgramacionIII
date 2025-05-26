import 'package:fitmanager/data/models/cliente_model.dart';
import 'package:fitmanager/data/repositories/cliente_repository.dart';
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
  List<Cliente> _clientes = [];
  List<Cliente> _resultados = [];

  @override
  void initState() {
    super.initState();
    _cargarClientes();
    _searchController.addListener(_filtrarClientes);
  }

  Future<void> _cargarClientes() async {
    final lista = await ClienteRepository().obtenerClientes();
    setState(() {
      _clientes = lista;
    });
  }

  void _filtrarClientes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _resultados =
          _clientes.where((cliente) {
            final nombre = cliente.nombre.toLowerCase();
            final codigo = cliente.id?.toLowerCase() ?? '';
            return nombre.contains(query) || codigo.contains(query);
          }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            const SizedBox(height: 20),
            if (_resultados.isNotEmpty)
              Column(
                children:
                    _resultados.map((cliente) {
                      return Card(
                        color: const Color(0xFF2A2A2A),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(
                            Icons.person,
                            color: Colors.orange,
                          ),
                          title: Text(
                            cliente.nombre,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            'Teléfono: ${cliente.telefono}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      );
                    }).toList(),
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
}

extension on int? {
  toLowerCase() {}
}
