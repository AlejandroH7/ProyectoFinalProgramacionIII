import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fitmanager/data/models/empleado_model.dart';
import 'package:fitmanager/data/repositories/empleado_repository.dart';

class NuevoEmpleadoPage extends StatefulWidget {
  const NuevoEmpleadoPage({super.key});

  @override
  State<NuevoEmpleadoPage> createState() => _NuevoEmpleadoPageState();
}

class _NuevoEmpleadoPageState extends State<NuevoEmpleadoPage> {
  final _formKey = GlobalKey<FormState>();

  String? nombre, sexo, telefono, area, usuario, clave;
  DateTime? fechaNacimiento;
  TimeOfDay? horaEntrada, horaSalida;
  List<String> diasSeleccionados = [];

  final List<String> diasSemana = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  final List<String> areas = [
    'Recepción',
    'Entrenador de pesas',
    'Nutricionista',
    'Cardio',
    'Limpieza',
  ];

  final List<String> sexos = ['Masculino', 'Femenino', 'Otro'];

  void _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(data: ThemeData.dark(), child: child!),
    );
    if (picked != null) {
      setState(() => fechaNacimiento = picked);
    }
  }

  void _seleccionarHora({required bool esEntrada}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) {
      setState(() {
        if (esEntrada) {
          horaEntrada = picked;
        } else {
          horaSalida = picked;
        }
      });
    }
  }

  Future<void> _registrarEmpleado() async {
    if (_formKey.currentState!.validate() &&
        sexo != null &&
        fechaNacimiento != null &&
        horaEntrada != null &&
        horaSalida != null &&
        area != null &&
        diasSeleccionados.isNotEmpty) {
      _formKey.currentState!.save();

      final nuevoEmpleado = Empleado(
        nombre: nombre!,
        sexo: sexo!,
        fechaNacimiento: DateFormat('yyyy-MM-dd').format(fechaNacimiento!),
        telefono: telefono!,
        horaEntrada: horaEntrada!.format(context),
        horaSalida: horaSalida!.format(context),
        area: area!,
        diasTrabajo: diasSeleccionados.join(', '),
        usuario: usuario!,
        clave: clave!,
      );

      await EmpleadoRepository().insertarEmpleado(nuevoEmpleado);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          title: const Text(
            'Empleado registrado',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'El empleado fue registrado exitosamente.',
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

      _formKey.currentState!.reset();
      setState(() {
        sexo = null;
        area = null;
        usuario = null;
        clave = null;
        fechaNacimiento = null;
        horaEntrada = null;
        horaSalida = null;
        diasSeleccionados.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete todos los campos')),
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
          'Nuevo Empleado',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Nombre completo', onSaved: (v) => nombre = v),
              _buildDropdown('Sexo', sexos, (val) => sexo = val),
              _buildFechaPicker(),
              _buildTextField('Teléfono', onSaved: (v) => telefono = v, keyboard: TextInputType.phone),
              _buildHora('Hora de entrada', true),
              _buildHora('Hora de salida', false),
              _buildDropdown('Área de trabajo', areas, (val) => area = val),
              _buildDiasDeTrabajo(),
              _buildTextField('Usuario', onSaved: (v) => usuario = v),
              _buildTextField('Clave', onSaved: (v) => clave = v, isPassword: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarEmpleado,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                ),
                child: const Text('Registrar nuevo empleado', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                ),
                child: const Text('Cancelar y volver', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {
    required void Function(String?) onSaved,
    bool isPassword = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        obscureText: isPassword,
        keyboardType: keyboard,
        style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        decoration: _inputDecoration(label),
        validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        decoration: _inputDecoration(label),
        dropdownColor: const Color.fromARGB(255, 192, 190, 190),
        items: options.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
        onChanged: onChanged,
        validator: (v) => (v == null || v.isEmpty) ? 'Seleccione una opción' : null,
        style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      ),
    );
  }

  Widget _buildFechaPicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: _seleccionarFecha,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                fechaNacimiento != null
                    ? DateFormat('yyyy-MM-dd').format(fechaNacimiento!)
                    : 'Fecha de nacimiento',
                style: const TextStyle(color: Colors.black87),
              ),
              const Icon(Icons.calendar_today, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHora(String label, bool esEntrada) {
    final TimeOfDay? hora = esEntrada ? horaEntrada : horaSalida;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: () => _seleccionarHora(esEntrada: esEntrada),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                hora != null ? hora.format(context) : label,
                style: const TextStyle(color: Colors.black87),
              ),
              const Icon(Icons.access_time, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiasDeTrabajo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Días de trabajo', style: TextStyle(color: Colors.white, fontSize: 14)),
        Wrap(
          spacing: 8,
          children: diasSemana.map((dia) {
            final seleccionado = diasSeleccionados.contains(dia);
            return FilterChip(
              selected: seleccionado,
              label: Text(dia),
              selectedColor: Colors.orange,
              backgroundColor: Colors.grey,
              labelStyle: const TextStyle(color: Colors.white),
              onSelected: (valor) {
                setState(() {
                  if (valor) {
                    diasSeleccionados.add(dia);
                  } else {
                    diasSeleccionados.remove(dia);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      hintText: label,
      hintStyle: const TextStyle(color: Colors.black54),
      filled: true,
      fillColor: Colors.grey[300],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
    );
  }
}


/*
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NuevoEmpleadoPage extends StatefulWidget {
  const NuevoEmpleadoPage({super.key});

  @override
  State<NuevoEmpleadoPage> createState() => _NuevoEmpleadoPageState();
}

class _NuevoEmpleadoPageState extends State<NuevoEmpleadoPage> {
  final _formKey = GlobalKey<FormState>();

  String? nombre, sexo, telefono, area, usuario, clave;
  DateTime? fechaNacimiento;
  TimeOfDay? horaEntrada, horaSalida;
  List<String> diasSeleccionados = [];

  final List<String> diasSemana = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  final List<String> areas = [
    'Recepción',
    'Entrenador de pesas',
    'Nutricionista',
    'Cardio',
    'Limpieza',
  ];

  final List<String> sexos = ['Masculino', 'Femenino', 'Otro'];

  void _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(data: ThemeData.dark(), child: child!),
    );
    if (picked != null) {
      setState(() => fechaNacimiento = picked);
    }
  }

  void _seleccionarHora({required bool esEntrada}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) {
      setState(() {
        if (esEntrada) {
          horaEntrada = picked;
        } else {
          horaSalida = picked;
        }
      });
    }
  }

  void _registrarEmpleado() {
    if (_formKey.currentState!.validate() &&
        sexo != null &&
        fechaNacimiento != null &&
        horaEntrada != null &&
        horaSalida != null &&
        area != null &&
        diasSeleccionados.isNotEmpty) {
      _formKey.currentState!.save();

      String codigo = 'EMP-${DateTime.now().millisecondsSinceEpoch % 10000}';
      String fecha = DateFormat('yyyy-MM-dd').format(fechaNacimiento!);
      String entrada = horaEntrada!.format(context);
      String salida = horaSalida!.format(context);
      String dias = diasSeleccionados.join(', ');

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              backgroundColor: const Color(0xFF2A2A2A),
              title: const Text(
                'Empleado registrado',
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                'Nombre: $nombre\nSexo: $sexo\nNacimiento: $fecha\n'
                'Teléfono: $telefono\nÁrea: $area\nEntrada: $entrada\nSalida: $salida\n'
                'Días: $dias\nUsuario: $usuario\nCódigo: $codigo',
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
        const SnackBar(content: Text('Complete todos los campos')),
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
          'Nuevo Empleado',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Nombre completo', onSaved: (v) => nombre = v),
              _buildDropdown('Sexo', sexos, (val) => sexo = val),
              _buildFechaPicker(),
              _buildTextField(
                'Teléfono',
                onSaved: (v) => telefono = v,
                keyboard: TextInputType.phone,
              ),
              _buildHora('Hora de entrada', true),
              _buildHora('Hora de salida', false),
              _buildDropdown('Área de trabajo', areas, (val) => area = val),
              _buildDiasDeTrabajo(),
              _buildTextField('Usuario', onSaved: (v) => usuario = v),
              _buildTextField(
                'Clave',
                onSaved: (v) => clave = v,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registrarEmpleado,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 24,
                  ),
                ),
                child: const Text(
                  'Registrar nuevo empleado',
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
    bool isPassword = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        obscureText: isPassword,
        keyboardType: keyboard,
        style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        decoration: _inputDecoration(label),
        validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        decoration: _inputDecoration(label),
        dropdownColor: const Color.fromARGB(
          255,
          192,
          190,
          190,
        ), // fondo gris claro
        items:
            options
                .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                .toList(),
        onChanged: onChanged,
        validator:
            (v) => (v == null || v.isEmpty) ? 'Seleccione una opción' : null,
        style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      ),
    );
  }

  Widget _buildFechaPicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: _seleccionarFecha,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                fechaNacimiento != null
                    ? DateFormat('yyyy-MM-dd').format(fechaNacimiento!)
                    : 'Fecha de nacimiento',
                style: const TextStyle(color: Colors.black87),
              ),
              const Icon(Icons.calendar_today, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHora(String label, bool esEntrada) {
    final TimeOfDay? hora = esEntrada ? horaEntrada : horaSalida;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: () => _seleccionarHora(esEntrada: esEntrada),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                hora != null ? hora.format(context) : label,
                style: const TextStyle(color: Colors.black87),
              ),
              const Icon(Icons.access_time, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiasDeTrabajo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Días de trabajo',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        Wrap(
          spacing: 8,
          children:
              diasSemana.map((dia) {
                final seleccionado = diasSeleccionados.contains(dia);
                return FilterChip(
                  selected: seleccionado,
                  label: Text(dia),
                  selectedColor: Colors.orange,
                  backgroundColor: Colors.grey,
                  labelStyle: const TextStyle(color: Colors.white),
                  onSelected: (valor) {
                    setState(() {
                      if (valor) {
                        diasSeleccionados.add(dia);
                      } else {
                        diasSeleccionados.remove(dia);
                      }
                    });
                  },
                );
              }).toList(),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      hintText: label,
      hintStyle: const TextStyle(color: Colors.black54),
      filled: true,
      fillColor: Colors.grey[300],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
    );
  }
}
*/
