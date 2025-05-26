import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitmanager/data/models/cliente_model.dart';
import 'package:fitmanager/data/repositories/cliente_repository.dart';

class RegistroClientesPage extends StatefulWidget {
  const RegistroClientesPage({super.key});

  @override
  State<RegistroClientesPage> createState() => _RegistroClientesPageState();
}

class _RegistroClientesPageState extends State<RegistroClientesPage> {
  List<Cliente> clientes = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

  Future<void> _cargarClientes() async {
    final lista = await ClienteRepository().obtenerClientes();
    setState(() {
      clientes = lista;
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          'Clientes registrados',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          cargando
              ? const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              )
              : clientes.isEmpty
              ? const Center(
                child: Text(
                  'No hay clientes registrados.',
                  style: TextStyle(color: Colors.white70),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: clientes.length,
                itemBuilder: (context, index) {
                  final cliente = clientes[index];
                  return Card(
                    color: const Color(0xFF2A2A2A),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.orange),
                      title: Text(
                        cliente.nombre,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sexo: ${cliente.sexo}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          Text(
                            'Teléfono: ${cliente.telefono}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          Text(
                            'Membresía desde: ${cliente.fechaInicioMembresia}',
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
