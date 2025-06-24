import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database;

  factory AppDatabase() => _instance;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE exercicio(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            comoFazer TEXT,
            intervalo TEXT,
            peso TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS treinos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            exercicios TEXT
          )
        ''');
      },
    );
  }
}
