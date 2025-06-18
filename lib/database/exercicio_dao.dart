
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
    print(result.map((map) => ExercicioModel.fromMap(map)).toList());
    return result.map((map) => ExercicioModel.fromMap(map)).toList();
  }
}
