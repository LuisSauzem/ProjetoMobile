import 'package:flutter/material.dart';
import '../models/exercicio_models.dart';
import '../models/treino_models.dart';
import '../service/exercicio_service.dart';
import '../database/treino_dao.dart';

class CadastroTreino extends StatefulWidget {
  const CadastroTreino({Key? key}) : super(key: key);

  @override
  State<CadastroTreino> createState() => _CadastroTreinoState();
}

class _CadastroTreinoState extends State<CadastroTreino> {
  final _nomeController = TextEditingController();
  final _exercicioService = ExercicioService();
  List<ExercicioModel> _exercicios = [];
  Set<int> _selecionados = {};

  @override
  void initState() {
    super.initState();
    _carregarExercicios();
  }

  Future<void> _carregarExercicios() async {
    final exercicios = await _exercicioService.getExercicios();
    setState(() {
      _exercicios = exercicios;
    });
  }

  Future<void> _salvarTreino() async {
    final nome = _nomeController.text.trim();
    if (nome.isEmpty || _selecionados.isEmpty) return;

    final novoTreino = TreinoModel(
      nome: nome,
      exercicios: _selecionados.toList(),
    );

    await TreinoDao().salvarTreino(novoTreino);

    if (!mounted) return;
    Navigator.of(context).pop(); // Volta para lista
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Treino')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome do treino'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _exercicios.isEmpty
                  ? const Center(child: Text('Nenhum exercício cadastrado.'))
                  : ListView(
                children: _exercicios.map((e) {
                  return CheckboxListTile(
                    title: Text(e.nome),
                    subtitle: Text("Peso: ${e.peso}"),
                    value: _selecionados.contains(e.id),
                    onChanged: (v) {
                      setState(() {
                        if (v == true) {
                          _selecionados.add(e.id!);
                        } else {
                          _selecionados.remove(e.id);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: _salvarTreino,
              child: const Text('Salvar'),
            )
          ],
        ),
      ),
    );
  }
}
