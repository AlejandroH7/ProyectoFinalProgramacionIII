import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitmanager/data/models/empleado_model.dart';
import 'package:fitmanager/data/repositories/empleado_repository.dart';

class EliminarEmpleadoPage extends StatefulWidget {
  const EliminarEmpleadoPage({super.key});

  @override
  State<EliminarEmpleadoPage> createState() => _EliminarEmpleadoPageState();
}

class _EliminarEmpleadoPageState extends State<EliminarEmpleadoPage> {
  List<Empleado> empleados = [];

  @override
  void initState() {
    super.initState();
    _cargarEmpleados();
  }

  Future<void> _cargarEmpleados() async {
    final data = await EmpleadoRepository().obtenerEmpleados();
    setState(() => empleados = data);
  }

  Future<void> _eliminarEmpleado(int id) async {
    await EmpleadoRepository().eliminarEmpleado(id);
    await _cargarEmpleados(); // Recarga la lista después de eliminar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Empleado eliminado correctamente'),
        backgroundColor: Colors.red[400],
      ),
    );
  }

  void _confirmarEliminacion(Empleado empleado) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            title: const Text(
              '¿Eliminar empleado?',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              '¿Desea eliminar a ${empleado.nombre}?',
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _eliminarEmpleado(empleado.id!);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Eliminar',
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
          'Eliminar empleado',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (empleados.isEmpty)
              const Text(
                'No hay empleados registrados.',
                style: TextStyle(color: Colors.white70),
              ),
            if (empleados.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: empleados.length,
                  itemBuilder: (context, index) {
                    final emp = empleados[index];
                    return Card(
                      color: const Color(0xFF2A2A2A),
                      child: ListTile(
                        leading: const Icon(
                          Icons.person_remove,
                          color: Colors.orange,
                        ),
                        title: Text(
                          emp.nombre,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Área: ${emp.area}  |  Usuario: ${emp.usuario}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => _confirmarEliminacion(emp),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: const Text(
                'Volver',
                style: TextStyle(color: Colors.white),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
