import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NuevaMaquinaPage extends StatefulWidget {
  const NuevaMaquinaPage({super.key});

  @override
  State<NuevaMaquinaPage> createState() => _NuevaMaquinaPageState();
}

class _NuevaMaquinaPageState extends State<NuevaMaquinaPage> {
  final _formKey = GlobalKey<FormState>();
  String? nombre, descripcion;
  int? cantidad;

  void _registrarMaquina() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String codigo = 'EQP-${DateTime.now().millisecondsSinceEpoch % 10000}';
      String fecha = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              backgroundColor: const Color(0xFF2A2A2A),
              title: const Text(
                'Máquina registrada',
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                'Código: $codigo\nNombre: $nombre\nCantidad: $cantidad\nDescripción: $descripcion\nFecha: $fecha',
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
            const Icon(Icons.fitness_center, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              'Nueva máquina o equipo',
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
              _buildTextField('Nombre', onSaved: (v) => nombre = v),
              _buildTextField(
                'Cantidad',
                onSaved: (v) => cantidad = int.tryParse(v ?? ''),
                keyboard: TextInputType.number,
              ),
              _buildTextField(
                'Breve descripción',
                onSaved: (v) => descripcion = v,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarMaquina,
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
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        onSaved: onSaved,
        validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
        keyboardType: keyboard,
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
}
