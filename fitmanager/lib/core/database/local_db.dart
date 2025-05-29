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
      version: 3, // ⬅️ Se sube la versión para aplicar los nuevos cambios
      onCreate: (db, version) async {
        await _crearTablas(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
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
      CREATE TABLE IF NOT EXISTS empleados(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        sexo TEXT,
        fechaNacimiento TEXT,
        telefono TEXT,
        area TEXT,
        horaEntrada TEXT,
        horaSalida TEXT,
        diasLaborales TEXT,
        usuario TEXT,
        clave TEXT
      )
    ''');
  }
}


/*
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
      version: 2, // ⬅️ Subimos la versión de la base de datos
      onCreate: (db, version) async {
        await _crearTablas(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
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
  }
}
*/