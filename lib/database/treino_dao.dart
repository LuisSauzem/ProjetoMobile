import '../models/treino_models.dart';
import 'appDatabase.dart';

class TreinoDao {
  static const String tableName = 'treinos';

  Future<int> salvarTreino(TreinoModel treino) async {
    final db = await AppDatabase().database;
    if (treino.id == null) {
      return await db.insert(tableName, treino.toMap());
    } else {
      return await db.update(
        tableName,
        treino.toMap(),
        where: 'id = ?',
        whereArgs: [treino.id],
      );
    }
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

  Future<TreinoModel?> getTreinoById(int id) async {
    final db = await AppDatabase().database;
    final maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return TreinoModel.fromMap(maps.first);
    }
    return null;
  }
}