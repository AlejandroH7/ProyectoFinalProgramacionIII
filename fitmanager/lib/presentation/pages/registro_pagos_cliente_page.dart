import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitmanager/data/models/cliente_model.dart';
import 'package:fitmanager/data/models/pago_model.dart';
import 'package:fitmanager/data/repositories/cliente_repository.dart';
import 'package:fitmanager/data/repositories/pago_repository.dart';

class RegistroPagosClientePage extends StatefulWidget {
  const RegistroPagosClientePage({super.key});

  @override
  State<RegistroPagosClientePage> createState() =>
      _RegistroPagosClientePageState();
}

class _RegistroPagosClientePageState extends State<RegistroPagosClientePage> {
  List<Cliente> clientes = [];
  Cliente? clienteSeleccionado;
  List<Pago> pagos = [];

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

  Future<void> _cargarClientes() async {
    final lista = await ClienteRepository().obtenerClientes();
    setState(() => clientes = lista);
  }

  Future<void> _cargarPagosDelCliente(int clienteId) async {
    final listaPagos = await PagoRepository().obtenerPagos();
    final filtrados =
        listaPagos.where((p) => p.clienteId == clienteId).toList()..sort(
          (a, b) => b.fechaPago.compareTo(a.fechaPago),
        ); // Orden descendente

    setState(() => pagos = filtrados);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          'Registro de pagos por cliente',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<Cliente>(
              value: clienteSeleccionado,
              items:
                  clientes.map((cliente) {
                    return DropdownMenuItem(
                      value: cliente,
                      child: Text('${cliente.nombre} (ID: ${cliente.id})'),
                    );
                  }).toList(),
              onChanged: (cliente) {
                setState(() => clienteSeleccionado = cliente);
                if (cliente != null) {
                  _cargarPagosDelCliente(cliente.id!);
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: 'Seleccionar cliente',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              dropdownColor: Colors.grey[200],
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 24),
            if (clienteSeleccionado != null)
              Text(
                'Historial de pagos de ${clienteSeleccionado!.nombre}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            const SizedBox(height: 12),
            Expanded(
              child:
                  pagos.isEmpty
                      ? const Center(
                        child: Text(
                          'Sin pagos registrados',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                      : ListView.builder(
                        itemCount: pagos.length,
                        itemBuilder: (context, index) {
                          final pago = pagos[index];
                          return Card(
                            color: const Color(0xFF2A2A2A),
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: const Icon(
                                Icons.payment,
                                color: Colors.orange,
                              ),
                              title: const Text(
                                'Pago registrado',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'Fecha: ${pago.fechaPago}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          );
                        },
                      ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.white),
              ),
              child: const Text(
                'Volver',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitmanager/data/models/cliente_model.dart';
import 'package:fitmanager/data/models/pago_model.dart';
import 'package:fitmanager/data/repositories/cliente_repository.dart';
import 'package:fitmanager/data/repositories/pago_repository.dart';

class RegistroPagosClientePage extends StatefulWidget {
  const RegistroPagosClientePage({super.key});

  @override
  State<RegistroPagosClientePage> createState() =>
      _RegistroPagosClientePageState();
}

class _RegistroPagosClientePageState extends State<RegistroPagosClientePage> {
  List<Cliente> clientes = [];
  Cliente? clienteSeleccionado;
  List<Pago> pagos = [];

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

  Future<void> _cargarClientes() async {
    final lista = await ClienteRepository().obtenerClientes();
    setState(() => clientes = lista);
  }

  Future<void> _cargarPagosDelCliente(int clienteId) async {
    final listaPagos = await PagoRepository().obtenerPagos();
    final filtrados =
        listaPagos.where((p) => p.clienteId == clienteId).toList();
    setState(() => pagos = filtrados);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          'Registro de pagos por cliente',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<Cliente>(
              value: clienteSeleccionado,
              items:
                  clientes.map((cliente) {
                    return DropdownMenuItem(
                      value: cliente,
                      child: Text('${cliente.nombre} (ID: ${cliente.id})'),
                    );
                  }).toList(),
              onChanged: (cliente) {
                setState(() => clienteSeleccionado = cliente);
                if (cliente != null) {
                  _cargarPagosDelCliente(cliente.id!);
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: 'Seleccionar cliente',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              dropdownColor: Colors.grey[200],
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 24),

            if (clienteSeleccionado != null)
              Text(
                'Historial de pagos de ${clienteSeleccionado!.nombre}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

            const SizedBox(height: 12),

            Expanded(
              child:
                  pagos.isEmpty
                      ? const Center(
                        child: Text(
                          'Sin pagos registrados',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                      : ListView.builder(
                        itemCount: pagos.length,
                        itemBuilder: (context, index) {
                          final pago = pagos[index];
                          return Card(
                            color: const Color(0xFF2A2A2A),
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: const Icon(
                                Icons.payment,
                                color: Colors.orange,
                              ),
                              title: const Text(
                                'Pago registrado',
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'Fecha: ${pago.fechaPago}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          );
                        },
                      ),
            ),

            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.white),
              ),
              child: const Text(
                'Volver',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
