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

    final confirmacion = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: const Text(
              '¿Confirmar pago?',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Por favor verifique que la información sea correcta.\n\n⚠️ Recuerde que los pagos no son editables.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('Confirmar'),
              ),
            ],
          ),
    );

    if (confirmacion != true) return;

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
*/
