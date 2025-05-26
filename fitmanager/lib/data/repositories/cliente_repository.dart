import 'package:fitmanager/core/database/local_db.dart';
import 'package:fitmanager/data/models/cliente_model.dart';
import 'package:sqflite/sqflite.dart';

class ClienteRepository {
  // Insertar un nuevo cliente
  Future<void> insertarCliente(Cliente cliente) async {
    final db = await LocalDatabase.getDatabase();
    await db.insert(
      'clientes',
      cliente.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todos los clientes
  Future<List<Cliente>> obtenerClientes() async {
    final db = await LocalDatabase.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('clientes');
    return maps.map((map) => Cliente.fromMap(map)).toList();
  }

  // Eliminar un cliente por ID
  Future<void> eliminarCliente(int id) async {
    final db = await LocalDatabase.getDatabase();
    await db.delete('clientes', where: 'id = ?', whereArgs: [id]);
  }

  // Actualizar un cliente
  Future<void> actualizarCliente(Cliente cliente) async {
    final db = await LocalDatabase.getDatabase();
    await db.update(
      'clientes',
      cliente.toMap(),
      where: 'id = ?',
      whereArgs: [cliente.id],
    );
  }
}
