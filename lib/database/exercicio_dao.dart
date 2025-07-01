
import 'package:projetomobile/models/exercicio_models.dart';

import 'appDatabase.dart';

class ExercicioDao {

  static const String table = 'exercicio';

  Future<int> insertExercicio(ExercicioModel exercicio) async {
    final db = await AppDatabase().database;
    return db.insert(table, exercicio.toMap());
  }

  Future<ExercicioModel?> getExercicio(String nome) async {
    final db = await AppDatabase().database;
    final result = await db.query(
      table,
      where: 'nome = ?',
      whereArgs: [nome],
    );
    return result.isNotEmpty ? ExercicioModel.fromMap(result.first) : null;
  }

  Future<List<ExercicioModel>> getAllExercicios() async {
    final db = await AppDatabase().database;
    final result = await db.query(table);
    return result.map((map) => ExercicioModel.fromMap(map)).toList();
  }

  Future<void> delete(int id) async {
    final db = await AppDatabase().database;
    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<int> updateExercicio(ExercicioModel exercicio) async {
    final db = await AppDatabase().database;
    print('intervalo dentro da dao '+exercicio.intervalo);
    print('id dentro da dao '+ exercicio.id.toString());
    return await db.update(
      table,
      exercicio.toMap(),
      where: 'id = ?',
      whereArgs: [exercicio.id],
    );
  }


}
