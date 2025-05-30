import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:fitmanager/data/repositories/cliente_repository.dart';
import 'package:fitmanager/data/repositories/pago_repository.dart';

class ClientesPorVencerPage extends StatefulWidget {
  const ClientesPorVencerPage({super.key});

  @override
  State<ClientesPorVencerPage> createState() => _ClientesPorVencerPageState();
}

class _ClientesPorVencerPageState extends State<ClientesPorVencerPage> {
  List<Map<String, dynamic>> clientesPorVencer = [];
  final Set<int> idsNotificados = {};

  @override
  void initState() {
    super.initState();
    _cargarClientesPorVencer();
  }

  Future<void> _cargarClientesPorVencer() async {
    final hoy = DateTime.now();
    final clientes = await ClienteRepository().obtenerClientes();
    final pagos = await PagoRepository().obtenerPagos();

    final List<Map<String, dynamic>> resultado = [];

    for (final cliente in clientes) {
      final pagosCliente =
          pagos.where((p) => p.clienteId == cliente.id).toList()
            ..sort((a, b) => b.fechaPago.compareTo(a.fechaPago));

      if (pagosCliente.isNotEmpty) {
        final ultimoPago = pagosCliente.first;
        final fechaPago = DateTime.parse(ultimoPago.fechaPago);
        final fechaVencimiento = fechaPago.add(const Duration(days: 30));
        final diasRestantes = fechaVencimiento.difference(hoy).inDays;

        if (diasRestantes >= 0 && diasRestantes <= 7) {
          resultado.add({
            'nombre': cliente.nombre,
            'codigo': 'CLT-${cliente.id.toString().padLeft(4, '0')}',
            'vence': DateFormat('yyyy-MM-dd').format(fechaVencimiento),
          });

          // Mostrar notificación solo una vez
          if (!idsNotificados.contains(cliente.id)) {
            _mostrarNotificacion(cliente.nombre);
            idsNotificados.add(cliente.id!);
          }
        }
      }
    }

    setState(() => clientesPorVencer = resultado);
  }

  void _mostrarNotificacion(String nombreCliente) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🔔 Membresía por vencer: $nombreCliente debe renovar pronto.',
        ),
        backgroundColor: Colors.orange[800],
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
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
          'Membresías por vencer',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Clientes con menos de 7 días de membresía restante:',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  clientesPorVencer.isEmpty
                      ? const Center(
                        child: Text(
                          'Ningún cliente por vencer pronto.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                      : ListView.builder(
                        itemCount: clientesPorVencer.length,
                        itemBuilder: (context, index) {
                          final cliente = clientesPorVencer[index];
                          return Card(
                            color: const Color(0xFF2A2A2A),
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: const Icon(
                                Icons.warning_amber,
                                color: Colors.orange,
                              ),
                              title: Text(
                                cliente['nombre'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                'Código: ${cliente['codigo']}\nVence: ${cliente['vence']}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
            const SizedBox(height: 12),
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
