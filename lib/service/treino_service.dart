
import '../models/treino_models.dart';
import '../database/treino_dao.dart';

class TreinoService {
  final TreinoDao _dao = TreinoDao();

  Future<void> salvarTreino(TreinoModel treino) {
    return _dao.salvarTreino(treino);
  }

  Future<List<TreinoModel>> listarTreinos() {
    return _dao.listarTreinos();
  }

  Future<void> deletarTreino(int id) {
    return _dao.deletarTreino(id);
  }
}
