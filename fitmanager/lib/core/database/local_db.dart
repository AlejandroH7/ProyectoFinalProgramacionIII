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

/*
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static Database? _database;

  // Getter para acceder a la base de datos
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    // Si no está inicializada, se crea
    _database = await _initDB('fitmanager.db');
    return _database!;
  }

  // Inicializa y crea las tablas si es necesario
  static Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // 🔧 Aquí se crean las tablas
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

        // Luego podemos agregar más tablas (empleados, pagos, etc.)
      },
    );
  }
}
*/
