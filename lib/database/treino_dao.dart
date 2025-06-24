import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/treino_models.dart';
import 'appDatabase.dart';

class TreinoDao {
  static const String tableName = 'treinos';


  Future<int> salvarTreino(TreinoModel treino) async {
    final db = await AppDatabase().database;
    return await db.insert(tableName, treino.toMap());
  }

  Future<List<TreinoModel>> listarTreinos() async {
    final db = await AppDatabase().database;
    final maps = await db.query(tableName);
    return maps.map((e) => TreinoModel.fromMap(e)).toList();
  }

  Future<int> deletarTreino(int id) async {
    final db = await AppDatabase().database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
