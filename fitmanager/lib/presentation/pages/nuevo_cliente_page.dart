import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fitmanager/data/models/cliente_model.dart';
import 'package:fitmanager/data/repositories/cliente_repository.dart';

class NuevoClientePage extends StatefulWidget {
  const NuevoClientePage({super.key});

  @override
  State<NuevoClientePage> createState() => _NuevoClientePageState();
}

class _NuevoClientePageState extends State<NuevoClientePage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  String? sexoSeleccionado;
  DateTime? fechaNacimiento;
  DateTime? fechaMembresia;
  bool aceptaTerminos = false;

  static int contadorClientes = 0;

  String _generarCodigoCliente() {
    contadorClientes++;
    return 'CLT-${contadorClientes.toString().padLeft(4, '0')}';
  }

  Future<void> _seleccionarFecha(
    BuildContext context,
    bool esNacimiento,
  ) async {
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

  Future<void> _registrarCliente() async {
    if (_validarFormulario()) {
      final codigo = _generarCodigoCliente();
      final fechaRegistro = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final nuevoCliente = Cliente(
        nombre: _nombreController.text,
        sexo: sexoSeleccionado!,
        fechaNacimiento: DateFormat('yyyy-MM-dd').format(fechaNacimiento!),
        telefono: _telefonoController.text,
        fechaInicioMembresia: DateFormat('yyyy-MM-dd').format(fechaMembresia!),
        estado: 'Activo', // Puedes ajustarlo según lógica futura
      );

      await ClienteRepository().insertarCliente(nuevoCliente);

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              backgroundColor: const Color(0xFF2A2A2A),
              title: const Text(
                'Cliente agregado',
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildResumen('Código de cliente', codigo),
                  _buildResumen('Nombre', _nombreController.text),
                  _buildResumen('Sexo', sexoSeleccionado ?? '-'),
                  _buildResumen('Fecha de registro', fechaRegistro),
                ],
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

      _nombreController.clear();
      _telefonoController.clear();
      setState(() {
        sexoSeleccionado = null;
        fechaNacimiento = null;
        fechaMembresia = null;
        aceptaTerminos = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos.')),
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
          'Nuevo cliente',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            _buildTextField('Nombre completo', _nombreController),
            const SizedBox(height: 15),
            _buildDropdownSexo(),
            const SizedBox(height: 15),
            _buildFechaSelector(
              label: 'Fecha de nacimiento',
              fecha: fechaNacimiento,
              onTap: () => _seleccionarFecha(context, true),
            ),
            const SizedBox(height: 15),
            _buildTextField(
              'Número de teléfono',
              _telefonoController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),
            _buildFechaSelector(
              label: 'Fecha de inicio de membresía',
              fecha: fechaMembresia,
              onTap: () => _seleccionarFecha(context, false),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Checkbox(
                  value: aceptaTerminos,
                  activeColor: Colors.orange,
                  onChanged: (value) {
                    setState(() => aceptaTerminos = value ?? false);
                  },
                ),
                Expanded(
                  child: Text(
                    'Acepta términos y condiciones',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildMainButton('Registrar nuevo cliente', _registrarCliente),
            const SizedBox(height: 12),
            _buildSecondaryButton('Cancelar y volver', () {
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  bool _validarFormulario() {
    return _nombreController.text.isNotEmpty &&
        _telefonoController.text.isNotEmpty &&
        sexoSeleccionado != null &&
        fechaNacimiento != null &&
        fechaMembresia != null &&
        aceptaTerminos;
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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
      value: sexoSeleccionado,
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
      onChanged: (value) => setState(() => sexoSeleccionado = value),
    );
  }

  Widget _buildFechaSelector({
    required String label,
    required DateTime? fecha,
    required VoidCallback onTap,
  }) {
    final texto =
        fecha != null ? DateFormat('yyyy-MM-dd').format(fecha) : label;
    return GestureDetector(
      onTap: onTap,
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

  Widget _buildMainButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF9800),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildResumen(String campo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        '$campo: $valor',
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NuevoClientePage extends StatefulWidget {
  const NuevoClientePage({super.key});

  @override
  State<NuevoClientePage> createState() => _NuevoClientePageState();
}

class _NuevoClientePageState extends State<NuevoClientePage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  String? sexoSeleccionado;
  DateTime? fechaNacimiento;
  DateTime? fechaMembresia;
  bool aceptaTerminos = false;

  static int contadorClientes = 0;

  String _generarCodigoCliente() {
    contadorClientes++;
    return 'CLT-${contadorClientes.toString().padLeft(4, '0')}';
  }

  Future<void> _seleccionarFecha(
    BuildContext context,
    bool esNacimiento,
  ) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          'Nuevo cliente',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            _buildTextField('Nombre completo', _nombreController),
            const SizedBox(height: 15),
            _buildDropdownSexo(),
            const SizedBox(height: 15),
            _buildFechaSelector(
              label: 'Fecha de nacimiento',
              fecha: fechaNacimiento,
              onTap: () => _seleccionarFecha(context, true),
            ),
            const SizedBox(height: 15),
            _buildTextField(
              'Número de teléfono',
              _telefonoController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),
            _buildFechaSelector(
              label: 'Fecha de inicio de membresía',
              fecha: fechaMembresia,
              onTap: () => _seleccionarFecha(context, false),
            ),
            const SizedBox(height: 25),

            Row(
              children: [
                Checkbox(
                  value: aceptaTerminos,
                  activeColor: Colors.orange,
                  onChanged: (value) {
                    setState(() {
                      aceptaTerminos = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'Acepta términos y condiciones',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Botón registrar
            _buildMainButton('Registrar nuevo cliente', () {
              if (_validarFormulario()) {
                final codigo = _generarCodigoCliente();
                final fechaRegistro = DateFormat(
                  'yyyy-MM-dd',
                ).format(DateTime.now());

                showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        backgroundColor: const Color(0xFF2A2A2A),
                        title: const Text(
                          'Cliente agregado',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildResumen('Código de cliente', codigo),
                            _buildResumen('Nombre', _nombreController.text),
                            _buildResumen('Sexo', sexoSeleccionado ?? '-'),
                            _buildResumen('Fecha de registro', fechaRegistro),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
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
                    content: Text('Por favor, complete todos los campos.'),
                  ),
                );
              }
            }),
            const SizedBox(height: 12),

            // Botón cancelar
            _buildSecondaryButton('Cancelar y volver', () {
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }

  bool _validarFormulario() {
    return _nombreController.text.isNotEmpty &&
        _telefonoController.text.isNotEmpty &&
        sexoSeleccionado != null &&
        fechaNacimiento != null &&
        fechaMembresia != null &&
        aceptaTerminos;
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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
      value: sexoSeleccionado,
      dropdownColor: const Color.fromARGB(
        255,
        192,
        190,
        190,
      ), // fondo gris claro
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[300], // fondo gris claro
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      ),
      hint: const Text('Sexo'),
      style: const TextStyle(color: Colors.black),
      items: const [
        DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
        DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
        DropdownMenuItem(value: 'Otro', child: Text('Otro')),
      ],
      onChanged: (value) => setState(() => sexoSeleccionado = value),
    );
  }

  Widget _buildFechaSelector({
    required String label,
    required DateTime? fecha,
    required VoidCallback onTap,
  }) {
    final texto =
        fecha != null ? DateFormat('yyyy-MM-dd').format(fecha) : label;
    return GestureDetector(
      onTap: onTap,
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

  Widget _buildMainButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF9800),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildResumen(String campo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        '$campo: $valor',
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}
*/
