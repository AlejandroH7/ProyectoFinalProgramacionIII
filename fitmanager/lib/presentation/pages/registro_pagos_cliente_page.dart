import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistroPagosClientePage extends StatefulWidget {
  const RegistroPagosClientePage({super.key});

  @override
  State<RegistroPagosClientePage> createState() =>
      _RegistroPagosClientePageState();
}

class _RegistroPagosClientePageState extends State<RegistroPagosClientePage> {
  String? clienteSeleccionado;

  // Simulación de datos
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
      {'fecha': '2024-04-10', 'monto': 'Q250'},
      {'fecha': '2024-03-10', 'monto': 'Q250'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final historial =
        clienteSeleccionado != null
            ? pagosPorCliente[clienteSeleccionado] ?? []
            : [];

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
            DropdownButtonFormField<String>(
              value: clienteSeleccionado,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                hintText: 'Seleccionar cliente',
              ),
              style: const TextStyle(color: Colors.black),
              dropdownColor: const Color.fromARGB(
                255,
                192,
                190,
                190,
              ), // fondo gris claro
              items:
                  pagosPorCliente.keys.map((nombre) {
                    return DropdownMenuItem(value: nombre, child: Text(nombre));
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  clienteSeleccionado = value;
                });
              },
            ),
            const SizedBox(height: 24),

            if (clienteSeleccionado != null)
              Text(
                'Historial de pagos de $clienteSeleccionado',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

            const SizedBox(height: 12),

            Expanded(
              child:
                  historial.isEmpty
                      ? Center(
                        child: Text(
                          clienteSeleccionado == null
                              ? 'Seleccione un cliente'
                              : 'Sin pagos registrados',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      )
                      : ListView.builder(
                        itemCount: historial.length,
                        itemBuilder: (context, index) {
                          final pago = historial[index];
                          return Card(
                            color: const Color(0xFF2A2A2A),
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: const Icon(
                                Icons.payment,
                                color: Colors.orange,
                              ),
                              title: Text(
                                '${pago['monto']}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                'Fecha: ${pago['fecha']}',
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
