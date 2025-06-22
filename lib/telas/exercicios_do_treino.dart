// lib/telas/exercicios_do_treino.dart
import 'package:flutter/material.dart';
import '../models/treino_models.dart';
import '../models/exercicio_models.dart';
import '../database/exercicio_dao.dart';

class ExerciciosDoTreino extends StatefulWidget {
  final TreinoModel treino;

  const ExerciciosDoTreino({Key? key, required this.treino}) : super(key: key);

  @override
  State<ExerciciosDoTreino> createState() => _ExerciciosDoTreinoState();
}

class _ExerciciosDoTreinoState extends State<ExerciciosDoTreino> {
  List<ExercicioModel> _exercicios = [];
  final _exercicioDao = ExercicioDao();

  @override
  void initState() {
    super.initState();
    _carregarExerciciosDoTreino();
  }

  Future<void> _carregarExerciciosDoTreino() async {
    final todos = await _exercicioDao.getAllExercicios();
    final relacionados = todos
        .where((e) => widget.treino.exercicios.contains(e.id))
        .toList();
    setState(() => _exercicios = relacionados);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Treino: ${widget.treino.nome}')),
      body: _exercicios.isEmpty
          ? const Center(child: Text('Nenhum exercício vinculado.'))
          : ListView.builder(
        itemCount: _exercicios.length,
        itemBuilder: (context, index) {
          final e = _exercicios[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(e.nome),
              subtitle: Text('Peso: ${e.peso} - Intervalo: ${e.intervalo}'),
            ),
          );
        },
      ),
    );
  }
}
