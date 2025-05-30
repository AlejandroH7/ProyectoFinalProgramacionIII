import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitmanager/data/models/empleado_model.dart';
import 'package:fitmanager/data/repositories/empleado_repository.dart';

class VerEmpleadosPage extends StatefulWidget {
  const VerEmpleadosPage({super.key});

  @override
  State<VerEmpleadosPage> createState() => _VerEmpleadosPageState();
}

class _VerEmpleadosPageState extends State<VerEmpleadosPage> {
  List<Empleado> empleados = [];

  @override
  void initState() {
    super.initState();
    _cargarEmpleados();
  }

  Future<void> _cargarEmpleados() async {
    final datos = await EmpleadoRepository().obtenerTodos();
    setState(() {
      empleados = datos;
    });
  }

  void _mostrarDialogoEditar(Empleado empleado) {
    final nombreCtrl = TextEditingController(text: empleado.nombre);
    final telefonoCtrl = TextEditingController(text: empleado.telefono);
    final areaCtrl = TextEditingController(text: empleado.area);

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: const Text(
              'Editar empleado',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                TextField(
                  controller: telefonoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                TextField(
                  controller: areaCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Área',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: () async {
                  final actualizado = empleado.copyWith(
                    nombre: nombreCtrl.text,
                    telefono: telefonoCtrl.text,
                    area: areaCtrl.text,
                  );
                  await EmpleadoRepository().actualizarEmpleado(actualizado);
                  Navigator.pop(context);
                  _cargarEmpleados();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Empleado actualizado correctamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Guardar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
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
          'Lista de empleados',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:
          empleados.isEmpty
              ? const Center(
                child: Text(
                  'No hay empleados registrados.',
                  style: TextStyle(color: Colors.white70),
                ),
              )
              : ListView.builder(
                itemCount: empleados.length,
                itemBuilder: (context, index) {
                  final emp = empleados[index];
                  return Card(
                    color: const Color(0xFF2A2A2A),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Colors.orange),
                      title: Text(
                        emp.nombre,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Área: ${emp.area}\nTeléfono: ${emp.telefono}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () => _mostrarDialogoEditar(emp),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
