import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> db() async {
    return openDatabase(
      join(await getDatabasesPath(), 'fitmanager.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE clientes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            sexo TEXT,
            fechaNacimiento TEXT,
            telefono TEXT,
            fechaInicioMembresia TEXT,
            estado TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE pagos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            clienteId INTEGER,
            fechaPago TEXT,
            FOREIGN KEY (clienteId) REFERENCES clientes(id)
          )
        ''');
      },
      version: 1,
    );
  }
}
