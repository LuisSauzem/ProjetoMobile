import 'package:projetomobile/models/exercicio_models.dart';

class Treino {
  String nome;
  List<ExercicioModel> listaExercicio;

  Treino({
    required this.nome,
    required this.listaExercicio,
  });

  static List<Treino> lista() {

    ExercicioModel E1 = ExercicioModel(
      id: '1',
      nome: 'Agachamento',
      comoFazer: 'Mantenha os pés afastados na largura dos ombros e flexione os joelhos até que as coxas fiquem paralelas ao chão.',
      intervalo: 60,
      peso: 40,
    );
    ExercicioModel E2 = ExercicioModel(
      id: '2',
      nome: 'Leg Press',
      comoFazer: 'Empurre a plataforma com os pés afastados na largura dos ombros, sem travar os joelhos ao estender as pernas.',
      intervalo: 45,
      peso: 80,
    );
    ExercicioModel E3 = ExercicioModel(
      id: '3',
      nome: 'Cadeira Extensora',
      comoFazer: 'Sente-se e estenda as pernas até que fiquem retas, contraindo o quadríceps.',
      intervalo: 30,
      peso: 25,
    );
    List<ExercicioModel> Lista1 = [E1, E2, E3];
    Treino T1 = Treino(nome: 'Treino A', listaExercicio: Lista1);

    ExercicioModel E4 = ExercicioModel(
      id: '4',
      nome: 'Supino Reto',
      comoFazer: 'Deite no banco e empurre a barra para cima, estendendo completamente os braços.',
      intervalo: 60,
      peso: 50,
    );
    ExercicioModel E5 = ExercicioModel(
      id: '5',
      nome: 'Crucifixo',
      comoFazer: 'Deitado no banco, abra os braços segurando halteres e retorne para a posição inicial.',
      intervalo: 50,
      peso: 30,
    );
    ExercicioModel E6 = ExercicioModel(
      id: '6',
      nome: 'Flexões',
      comoFazer: 'Mantenha o corpo reto e abaixe até quase tocar o chão com o peito, depois empurre para cima.',
      intervalo: 40,
      peso: 0, // Peso corporal
    );
    List<ExercicioModel> Lista2 = [E4, E5, E6];
    Treino T2 = Treino(nome: 'Treino B', listaExercicio: Lista2);

    List<Treino> treinos = [T1, T2];

    return treinos;
  }
}
