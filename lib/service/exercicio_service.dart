

import 'package:projetomobile/database/exercicio_dao.dart';

import '../models/exercicio_models.dart';

class ExercicioService {
  final ExercicioDao _exercicioDao = ExercicioDao();

  Future<int> addExercicio(ExercicioModel exercicio) async {
    return await _exercicioDao.insertExercicio(exercicio);
  }

  Future<List<ExercicioModel>> getExercicios() async{
    return await _exercicioDao.getAllExercicios();
  }
}