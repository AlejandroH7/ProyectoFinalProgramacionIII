import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fitmanager/data/models/cliente_model.dart';
import 'package:fitmanager/data/models/pago_model.dart';
import 'package:fitmanager/data/repositories/cliente_repository.dart';
import 'package:fitmanager/data/repositories/pago_repository.dart';

class RealizarPagoPage extends StatefulWidget {
  const RealizarPagoPage({super.key});

  @override
  State<RealizarPagoPage> createState() => _RealizarPagoPageState();
}

class _RealizarPagoPageState extends State<RealizarPagoPage> {
  List<Cliente> clientes = [];
  Cliente? clienteSeleccionado;
  DateTime? fechaSeleccionada;

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

  Future<void> _cargarClientes() async {
    final lista = await ClienteRepository().obtenerClientes();
    setState(() => clientes = lista);
  }

  Future<void> _seleccionarFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      builder:
          (context, child) => Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.orange,
                surface: Color(0xFF2A2A2A),
              ),
            ),
            child: child!,
          ),
    );

    if (picked != null) {
      setState(() => fechaSeleccionada = picked);
    }
  }

  Future<void> _registrarPago() async {
    if (clienteSeleccionado == null || fechaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar cliente y fecha')),
      );
      return;
    }

    final nuevoPago = Pago(
      clienteId: clienteSeleccionado!.id!,
      fechaPago: DateFormat('yyyy-MM-dd').format(fechaSeleccionada!),
    );

    await PagoRepository().insertarPago(nuevoPago);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: const Text(
              'Pago registrado',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Cliente: ${clienteSeleccionado!.nombre}\nFecha: ${DateFormat('dd/MM/yyyy').format(fechaSeleccionada!)}',
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fechaTexto =
        fechaSeleccionada != null
            ? DateFormat('dd/MM/yyyy').format(fechaSeleccionada!)
            : 'Seleccionar fecha de pago';

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          'Realizar pago de membresía',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
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
              onChanged: (value) => setState(() => clienteSeleccionado = value),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: 'Seleccionar cliente',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _seleccionarFecha,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  fechaTexto,
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _registrarPago,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Registrar pago',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: const BorderSide(color: Colors.white),
                ),
                child: const Text(
                  'Cancelar y volver',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
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
import 'package:intl/intl.dart';

class RealizarPagoPage extends StatefulWidget {
  const RealizarPagoPage({super.key});

  @override
  State<RealizarPagoPage> createState() => _RealizarPagoPageState();
}

class _RealizarPagoPageState extends State<RealizarPagoPage> {
  String? clienteSeleccionado;
  DateTime? fechaSeleccionada;

  final List<String> clientes = [
    'Carlos Pérez (CLT-0001)',
    'María López (CLT-0002)',
    'Luis Gómez (CLT-0003)',
  ];

  void _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder:
          (context, child) => Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.orange,
                surface: Color(0xFF2A2A2A),
              ),
            ),
            child: child!,
          ),
    );

    if (picked != null) {
      setState(() {
        fechaSeleccionada = picked;
      });
    }
  }

  void _registrarPago() {
    if (clienteSeleccionado != null && fechaSeleccionada != null) {
      final String fechaFormateada = DateFormat(
        'yyyy-MM-dd',
      ).format(fechaSeleccionada!);

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              backgroundColor: const Color(0xFF2A2A2A),
              title: const Text(
                'Pago registrado',
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                'Cliente: $clienteSeleccionado\nFecha de pago: $fechaFormateada',
                style: const TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, seleccione un cliente y una fecha'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          'Realizar pago de membresía',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDropdown(
              label: 'Seleccionar cliente',
              valor: clienteSeleccionado,
              items: clientes,
              onChanged: (value) => setState(() => clienteSeleccionado = value),
            ),
            const SizedBox(height: 16),
            _buildSelectorFecha(),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _registrarPago,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9800),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Registrar pago',
                style: TextStyle(color: Colors.white),
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
                'Cancelar y volver',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? valor,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: valor,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        hintText: label,
      ),
      style: const TextStyle(color: Colors.black),
      dropdownColor: const Color.fromARGB(
        255,
        192,
        190,
        190,
      ), // fondo gris claro
      items:
          items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSelectorFecha() {
    final texto =
        fechaSeleccionada != null
            ? DateFormat('dd/MM/yyyy').format(fechaSeleccionada!)
            : 'Seleccionar fecha de pago';

    return GestureDetector(
      onTap: _seleccionarFecha,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(texto, style: const TextStyle(color: Colors.black87)),
      ),
    );
  }
}
*/
