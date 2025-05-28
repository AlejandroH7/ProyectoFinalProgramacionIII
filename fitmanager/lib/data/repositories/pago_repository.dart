import 'package:fitmanager/data/helpers/db_helper.dart';
import 'package:fitmanager/data/models/pago_model.dart';
import 'package:sqflite/sqflite.dart';

class PagoRepository {
  // Insertar un nuevo pago
  Future<void> insertarPago(Pago pago) async {
    final db = await DBHelper.db();
    await db.insert(
      'pagos',
      pago.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todos los pagos de un cliente (historial)
  Future<List<Pago>> obtenerPagosPorCliente(int clienteId) async {
    final db = await DBHelper.db();
    final List<Map<String, dynamic>> maps = await db.query(
      'pagos',
      where: 'clienteId = ?', // 👈 importante que coincida con tu modelo
      whereArgs: [clienteId],
      orderBy: 'fechaPago DESC',
    );
    return maps.map((map) => Pago.fromMap(map)).toList();
  }

  // ✅ Obtener todos los pagos (usado por clientes_por_vencer_page.dart)
  Future<List<Pago>> obtenerPagos() async {
    final db = await DBHelper.db();
    final List<Map<String, dynamic>> maps = await db.query('pagos');
    return maps.map((map) => Pago.fromMap(map)).toList();
  }

  // Obtener el último pago registrado por cada cliente
  Future<Map<int, String>> obtenerUltimosPagosPorCliente() async {
    final db = await DBHelper.db();
    final result = await db.rawQuery('''
      SELECT clienteId, MAX(fechaPago) AS ultimo_pago
      FROM pagos
      GROUP BY clienteId
    ''');

    final Map<int, String> ultimosPagos = {};
    for (final row in result) {
      ultimosPagos[row['clienteId'] as int] = row['ultimo_pago'] as String;
    }

    return ultimosPagos;
  }
}
