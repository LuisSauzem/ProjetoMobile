// lib/telas/lista_treinos.dart
import 'package:flutter/material.dart';
import '../models/treino_models.dart';
import '../service/treino_service.dart';
import '../database/exercicio_dao.dart';
import '../models/exercicio_models.dart';
import 'cadastroTreino.dart';
import 'exercicios_do_treino.dart';

class ListaTreinos extends StatefulWidget {
  const ListaTreinos({Key? key}) : super(key: key);

  @override
  State<ListaTreinos> createState() => _ListaTreinosState();
}

class _ListaTreinosState extends State<ListaTreinos> {
  final _treinoService = TreinoService();
  final _exercicioDao = ExercicioDao();

  List<TreinoModel> _treinos = [];

  @override
  void initState() {
    super.initState();
    _carregarTreinos();
  }

  Future<void> _carregarTreinos() async {
    final treinos = await _treinoService.listarTreinos();
    setState(() => _treinos = treinos);
  }

  Future<void> _excluirTreino(int id) async {
    await _treinoService.deletarTreino(id);
    _carregarTreinos();
  }

  Future<List<ExercicioModel>> _buscarExercicios(TreinoModel treino) async {
    List<ExercicioModel> todos = await _exercicioDao.getAllExercicios();
    return todos.where((e) => treino.exercicios.contains(e.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Treinos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CadastroTreino()),
          );
          _carregarTreinos();
        },
        child: const Icon(Icons.add),
      ),
      body: _treinos.isEmpty
          ? const Center(child: Text('Nenhum treino cadastrado.'))
          : ListView.builder(
        itemCount: _treinos.length,
        itemBuilder: (context, index) {
          final treino = _treinos[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExerciciosDoTreino(treino: treino),
                  ),
                );
              },
              title: Text(treino.nome),
              subtitle: FutureBuilder<List<ExercicioModel>>(
                future: _buscarExercicios(treino),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('Carregando exercícios...');
                  final exercicios = snapshot.data!;
                  if (exercicios.isEmpty) return const Text('Sem exercícios.');
                  return Text(exercicios.map((e) => e.nome).join(', '));
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _excluirTreino(treino.id!),
              ),
            ),
          );
        },
      ),
    );
  }
}
