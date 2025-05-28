import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:fitmanager/data/models/cliente_model.dart';
import 'package:fitmanager/data/models/pago_model.dart';
import 'package:fitmanager/data/repositories/cliente_repository.dart';
import 'package:fitmanager/data/repositories/pago_repository.dart';

class GenerarReciboPage extends StatefulWidget {
  const GenerarReciboPage({super.key});

  @override
  State<GenerarReciboPage> createState() => _GenerarReciboPageState();
}

class _GenerarReciboPageState extends State<GenerarReciboPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Cliente> clientes = [];
  Cliente? clienteSeleccionado;
  List<Pago> pagosDelCliente = [];
  Pago? pagoSeleccionado;

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
    final pagos = await PagoRepository().obtenerPagos();
    final filtrados =
        pagos.where((p) => p.clienteId == clienteId).toList()..sort(
          (a, b) => b.fechaPago.compareTo(a.fechaPago),
        ); // más recientes primero
    setState(() => pagosDelCliente = filtrados);
  }

  @override
  Widget build(BuildContext context) {
    final filtro = _searchController.text.toLowerCase();
    final clientesFiltrados =
        clientes.where((c) => c.nombre.toLowerCase().contains(filtro)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          'Generar recibo',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar cliente',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Etapas del flujo:
            if (clienteSeleccionado == null)
              Expanded(
                child: ListView.builder(
                  itemCount: clientesFiltrados.length,
                  itemBuilder: (context, index) {
                    final cliente = clientesFiltrados[index];
                    return Card(
                      color: const Color(0xFF2A2A2A),
                      child: ListTile(
                        title: Text(
                          '${cliente.nombre} (ID: ${cliente.id})',
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white54,
                          size: 16,
                        ),
                        onTap: () {
                          setState(() {
                            clienteSeleccionado = cliente;
                            pagoSeleccionado = null;
                            _cargarPagosDelCliente(cliente.id!);
                          });
                        },
                      ),
                    );
                  },
                ),
              )
            else if (pagoSeleccionado == null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pagos de ${clienteSeleccionado!.nombre}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child:
                          pagosDelCliente.isEmpty
                              ? const Text(
                                'Este cliente no tiene pagos registrados.',
                                style: TextStyle(color: Colors.white70),
                              )
                              : ListView.builder(
                                itemCount: pagosDelCliente.length,
                                itemBuilder: (context, index) {
                                  final pago = pagosDelCliente[index];
                                  return Card(
                                    color: const Color(0xFF2A2A2A),
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.receipt_long,
                                        color: Colors.orange,
                                      ),
                                      title: const Text(
                                        'Pago registrado',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        'Fecha: ${pago.fechaPago}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          pagoSeleccionado = pago;
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recibo generado',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cliente: ${clienteSeleccionado!.nombre}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Fecha de pago: ${pagoSeleccionado!.fechaPago}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Código de recibo: RCB-${DateTime.now().millisecondsSinceEpoch}',
                            style: const TextStyle(color: Colors.white54),
                          ),
                          Text(
                            'Generado: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                            style: const TextStyle(color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Recibo generado.')),
                        );
                      },
                      icon: const Icon(Icons.download, color: Colors.white),
                      label: const Text(
                        'Descargar recibo',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9800),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                if (pagoSeleccionado != null) {
                  setState(() => pagoSeleccionado = null);
                } else if (clienteSeleccionado != null) {
                  setState(() => clienteSeleccionado = null);
                } else {
                  Navigator.pop(context);
                }
              },
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
