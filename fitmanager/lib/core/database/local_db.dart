import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await _initDB('fitmanager.db');
    return _database!;
  }

  static Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 4, // ⬅️ Cambiamos a una versión más alta para forzar recreación
      onCreate: (db, version) async {
        await _crearTablas(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Elimina y vuelve a crear la tabla empleados para evitar errores
        await db.execute('DROP TABLE IF EXISTS empleados');
        await _crearTablas(db);
      },
    );
  }

  static Future<void> _crearTablas(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS clientes(
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
      CREATE TABLE IF NOT EXISTS pagos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clienteId INTEGER,
        fechaPago TEXT,
        FOREIGN KEY (clienteId) REFERENCES clientes(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE empleados(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        sexo TEXT,
        fechaNacimiento TEXT,
        telefono TEXT,
        horaEntrada TEXT,
        horaSalida TEXT,
        area TEXT,
        diasTrabajo TEXT, -- ✅ CAMBIO AQUÍ
        usuario TEXT,
        clave TEXT
      )
    ''');
  }
}
