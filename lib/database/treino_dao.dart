import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/treino_models.dart';

class TreinoDao {
  static const String tableName = 'treinos';

  Future<Database> _getDatabase() async {
    final path = join(await getDatabasesPath(), 'app.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            exercicios TEXT
          )
        ''');
      },
    );
  }

  Future<int> salvarTreino(TreinoModel treino) async {
    final db = await _getDatabase();
    return await db.insert(tableName, treino.toMap());
  }

  Future<List<TreinoModel>> listarTreinos() async {
    final db = await _getDatabase();
    final maps = await db.query(tableName);
    return maps.map((e) => TreinoModel.fromMap(e)).toList();
  }

  Future<int> deletarTreino(int id) async {
    final db = await _getDatabase();
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
