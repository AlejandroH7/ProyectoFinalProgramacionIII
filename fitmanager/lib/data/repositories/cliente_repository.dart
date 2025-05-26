import 'package:sqflite/sqflite.dart';
import 'package:fitmanager/core/database/local_db.dart';
import 'package:fitmanager/data/models/cliente_model.dart';

class ClienteRepository {
  // Insertar un nuevo cliente
  static Future<void> insertarCliente(Cliente cliente) async {
    final db = await LocalDatabase.getDatabase();
    await db.insert(
      'clientes',
      cliente.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todos los clientes registrados
  static Future<List<Cliente>> obtenerClientes() async {
    final db = await LocalDatabase.getDatabase();
    final List<Map<String, dynamic>> resultado = await db.query('clientes');

    return resultado.map((mapa) => Cliente.fromMap(mapa)).toList();
  }
}
