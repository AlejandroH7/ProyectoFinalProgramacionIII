import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fitmanager/data/models/cliente_model.dart';
import 'package:fitmanager/data/repositories/cliente_repository.dart';

class EditarClientePage extends StatefulWidget {
  final Cliente cliente;

  const EditarClientePage({super.key, required this.cliente});

  @override
  State<EditarClientePage> createState() => _EditarClientePageState();
}

class _EditarClientePageState extends State<EditarClientePage> {
  late TextEditingController _nombreController;
  late TextEditingController _telefonoController;
  String? sexo;
  DateTime? fechaNacimiento;
  DateTime? fechaMembresia;

  @override
  void initState() {
    super.initState();
    final cliente = widget.cliente;

    _nombreController = TextEditingController(text: cliente.nombre);
    _telefonoController = TextEditingController(text: cliente.telefono);
    sexo = cliente.sexo;

    try {
      fechaNacimiento = DateFormat('yyyy-MM-dd').parse(cliente.fechaNacimiento);
    } catch (_) {
      fechaNacimiento = null;
    }

    try {
      fechaMembresia = DateFormat(
        'yyyy-MM-dd',
      ).parse(cliente.fechaInicioMembresia);
    } catch (_) {
      fechaMembresia = null;
    }
  }

  Future<void> _seleccionarFecha(bool esNacimiento) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
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
        esNacimiento ? fechaNacimiento = picked : fechaMembresia = picked;
      });
    }
  }

  Future<void> _guardarCambios() async {
    if (_nombreController.text.isEmpty ||
        _telefonoController.text.isEmpty ||
        sexo == null ||
        fechaNacimiento == null ||
        fechaMembresia == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
      return;
    }

    final clienteActualizado = Cliente(
      id: widget.cliente.id,
      nombre: _nombreController.text,
      sexo: sexo!,
      fechaNacimiento: DateFormat('yyyy-MM-dd').format(fechaNacimiento!),
      telefono: _telefonoController.text,
      fechaInicioMembresia: DateFormat('yyyy-MM-dd').format(fechaMembresia!),
      estado: widget.cliente.estado,
    );

    await ClienteRepository().actualizarCliente(clienteActualizado);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          'Editar cliente',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildTextField('Nombre completo', _nombreController),
            const SizedBox(height: 15),
            _buildDropdownSexo(),
            const SizedBox(height: 15),
            _buildFechaSelector('Fecha de nacimiento', fechaNacimiento, true),
            const SizedBox(height: 15),
            _buildTextField(
              'Teléfono',
              _telefonoController,
              tipo: TextInputType.phone,
            ),
            const SizedBox(height: 15),
            _buildFechaSelector('Inicio de membresía', fechaMembresia, false),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: _guardarCambios,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 24,
                ),
              ),
              child: const Text(
                'Guardar cambios',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType tipo = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: tipo,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  Widget _buildDropdownSexo() {
    return DropdownButtonFormField<String>(
      value: sexo,
      dropdownColor: Colors.grey[200],
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      ),
      hint: const Text('Sexo'),
      style: const TextStyle(color: Colors.black),
      items: const [
        DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
        DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
        DropdownMenuItem(value: 'Otro', child: Text('Otro')),
      ],
      onChanged: (value) => setState(() => sexo = value),
    );
  }

  Widget _buildFechaSelector(String label, DateTime? fecha, bool esNacimiento) {
    final texto =
        fecha != null ? DateFormat('yyyy-MM-dd').format(fecha) : label;
    return GestureDetector(
      onTap: () => _seleccionarFecha(esNacimiento),
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
