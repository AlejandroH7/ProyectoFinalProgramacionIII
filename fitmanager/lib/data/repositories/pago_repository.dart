import 'package:fitmanager/data/models/pago_model.dart';
import 'package:fitmanager/data/helpers/db_helper.dart';

class PagoRepository {
  Future<void> insertarPago(Pago pago) async {
    final db = await DBHelper.db();
    await db.insert('pagos', pago.toMap());
  }

  Future<List<Pago>> obtenerPagos() async {
    final db = await DBHelper.db();
    final maps = await db.query('pagos');
    return List.generate(maps.length, (i) => Pago.fromMap(maps[i]));
  }
}
