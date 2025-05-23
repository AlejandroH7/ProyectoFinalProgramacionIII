import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FechaMantenimientoPage extends StatefulWidget {
  const FechaMantenimientoPage({super.key});

  @override
  State<FechaMantenimientoPage> createState() => _FechaMantenimientoPageState();
}

class _FechaMantenimientoPageState extends State<FechaMantenimientoPage> {
  final _formKey = GlobalKey<FormState>();
  String? equipo, descripcion;
  DateTime? fecha;

  void _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      builder:
          (context, child) => Theme(
            data: ThemeData.dark().copyWith(
              primaryColor: Colors.orange,
              colorScheme: const ColorScheme.dark(primary: Colors.orange),
            ),
            child: child!,
          ),
    );
    if (picked != null) {
      setState(() => fecha = picked);
    }
  }

  void _registrarMantenimiento() {
    if (_formKey.currentState!.validate() && fecha != null) {
      _formKey.currentState!.save();

      String fechaStr = DateFormat('yyyy-MM-dd').format(fecha!);
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              backgroundColor: const Color(0xFF2A2A2A),
              title: const Text(
                'Mantenimiento registrado',
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                'Máquina/equipo: $equipo\nFecha: $fechaStr\nDescripción: $descripcion',
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Selecciona una fecha')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'Fecha de mantenimiento',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Máquina o equipo', onSaved: (v) => equipo = v),
              _buildFechaField(),
              _buildTextField(
                'Breve descripción',
                onSaved: (v) => descripcion = v,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarMantenimiento,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text(
                  'Registrar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
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
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    required void Function(String?) onSaved,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        onSaved: onSaved,
        validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(color: Colors.black54),
          filled: true,
          fillColor: Colors.grey[300],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  Widget _buildFechaField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: _seleccionarFecha,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.black26),
          ),
          child: Text(
            fecha != null
                ? DateFormat('yyyy-MM-dd').format(fecha!)
                : 'Seleccionar fecha',
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
