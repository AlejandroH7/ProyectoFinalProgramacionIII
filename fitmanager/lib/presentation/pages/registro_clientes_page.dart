import 'package:fitmanager/presentation/pages/editar_cliente_page.dart';
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

  void _mostrarDialogoCliente(Cliente cliente) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: Text(
              'Cliente: ${cliente.nombre}',
              style: const TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID: ${cliente.id}',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  'Sexo: ${cliente.sexo}',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  'Nacimiento: ${cliente.fechaNacimiento}',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  'Teléfono: ${cliente.telefono}',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  'Membresía: ${cliente.fechaInicioMembresia}',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  'Estado: ${cliente.estado}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  final actualizado = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditarClientePage(cliente: cliente),
                    ),
                  );
                  if (actualizado == true) {
                    _cargarClientes();
                  }
                },
                child: const Text(
                  'Editar',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await ClienteRepository().eliminarCliente(cliente.id!);
                  Navigator.pop(context);
                  _cargarClientes(); // Refresca después de eliminar
                },
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cerrar',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
    );
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
                      onTap: () => _mostrarDialogoCliente(cliente),
                    ),
                  );
                },
              ),
    );
  }
}
