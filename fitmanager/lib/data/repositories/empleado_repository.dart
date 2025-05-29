import 'package:fitmanager/data/models/empleado_model.dart';
import 'package:fitmanager/core/database/local_db.dart';

class EmpleadoRepository {
  Future<void> insertarEmpleado(Empleado empleado) async {
    final db = await LocalDatabase.getDatabase();
    await db.insert('empleados', empleado.toMap());
  }

  Future<List<Empleado>> obtenerEmpleados() async {
    final db = await LocalDatabase.getDatabase();
    final result = await db.query('empleados');
    return result.map((e) => Empleado.fromMap(e)).toList();
  }

  Future<void> eliminarEmpleado(int id) async {
    final db = await LocalDatabase.getDatabase();
    await db.delete('empleados', where: 'id = ?', whereArgs: [id]);
  }
}
