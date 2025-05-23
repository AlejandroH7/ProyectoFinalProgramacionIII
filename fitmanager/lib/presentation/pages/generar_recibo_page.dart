import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class GenerarReciboPage extends StatefulWidget {
  const GenerarReciboPage({super.key});

  @override
  State<GenerarReciboPage> createState() => _GenerarReciboPageState();
}

class _GenerarReciboPageState extends State<GenerarReciboPage> {
  final TextEditingController _searchController = TextEditingController();
  String? clienteSeleccionado;
  Map<String, String>? pagoSeleccionado;

  final Map<String, List<Map<String, String>>> pagosPorCliente = {
    'Carlos Pérez (CLT-0001)': [
      {'fecha': '2024-05-01', 'monto': 'Q200'},
      {'fecha': '2024-04-01', 'monto': 'Q200'},
    ],
    'María López (CLT-0002)': [
      {'fecha': '2024-04-15', 'monto': 'Q200'},
    ],
    'Luis Gómez (CLT-0003)': [
      {'fecha': '2024-05-10', 'monto': 'Q250'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final filtro = _searchController.text.toLowerCase();
    final clientesFiltrados =
        pagosPorCliente.keys.where((cliente) {
          return cliente.toLowerCase().contains(filtro);
        }).toList();

    final pagos =
        clienteSeleccionado != null
            ? pagosPorCliente[clienteSeleccionado] ?? []
            : [];

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
                          cliente,
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Pagos de $clienteSeleccionado',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child:
                          pagos.isEmpty
                              ? const Text(
                                'Este cliente no tiene pagos registrados.',
                                style: TextStyle(color: Colors.white70),
                              )
                              : ListView.builder(
                                itemCount: pagos.length,
                                itemBuilder: (context, index) {
                                  final pago = pagos[index];
                                  return Card(
                                    color: const Color(0xFF2A2A2A),
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.receipt_long,
                                        color: Colors.orange,
                                      ),
                                      title: Text(
                                        'Q${pago['monto']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Fecha: ${pago['fecha']}',
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            'Cliente: $clienteSeleccionado',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Monto: Q${pagoSeleccionado!['monto']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Fecha de pago: ${pagoSeleccionado!['fecha']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Código de recibo: RCB-${DateTime.now().millisecondsSinceEpoch}',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Fecha de generación: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Recibo generado. (Simulación de descarga)',
                            ),
                          ),
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
                side: const BorderSide(color: Colors.white),
                padding: const EdgeInsets.symmetric(vertical: 14),
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
