import 'package:flutter/material.dart';
import 'package:projetomobile/models/exercicio_models.dart';
import 'package:projetomobile/models/treino_models.dart';
import 'package:projetomobile/database/exercicio_dao.dart';
import 'package:projetomobile/database/treino_dao.dart';

class EditarTreinoScreen extends StatefulWidget {
  final TreinoModel treino;

  const EditarTreinoScreen({Key? key, required this.treino}) : super(key: key);

  @override
  _EditarTreinoScreenState createState() => _EditarTreinoScreenState();
}

class _EditarTreinoScreenState extends State<EditarTreinoScreen> {
  late TextEditingController _nomeController;
  late List<ExercicioModel> _todosExercicios;
  late Set<int> _exerciciosSelecionados;
  final _exercicioDao = ExercicioDao();
  final _treinoDao = TreinoDao();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.treino.nome);
    _exerciciosSelecionados = widget.treino.exercicios.toSet();
    _carregarExercicios();
  }

  Future<void> _carregarExercicios() async {
    _todosExercicios = await _exercicioDao.getAllExercicios();
    setState(() => _isLoading = false);
  }

  Future<void> _salvarTreino() async {
    if (_nomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, insira um nome para o treino'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final treinoAtualizado = TreinoModel(
      id: widget.treino.id,
      nome: _nomeController.text,
      exercicios: _exerciciosSelecionados.toList(),
    );

    await _treinoDao.salvarTreino(treinoAtualizado);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text('EDITAR TREINO', style: TextStyle(
          fontFamily: 'BebasNeue',
          fontSize: 24,
          letterSpacing: 1.5,
          color: Colors.white,
        )),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.orangeAccent),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A1A),
              Color(0xFF121212),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nomeController,
                      decoration: InputDecoration(
                        labelText: 'Nome do Treino',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Color(0xFF1E1E1E),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Text('Selecione os exercícios:', style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                    SizedBox(height: 10),
                    Expanded(
                      child: _isLoading
                          ? Center(child: CircularProgressIndicator(color: Colors.orangeAccent))
                          : ListView.builder(
                        itemCount: _todosExercicios.length,
                        itemBuilder: (context, index) {
                          final exercicio = _todosExercicios[index];
                          return CheckboxListTile(
                            title: Text(exercicio.nome, style: TextStyle(color: Colors.white)),
                            subtitle: Text('${exercicio.peso}kg - ${exercicio.intervalo}s',
                                style: TextStyle(color: Colors.white70)),
                            value: _exerciciosSelecionados.contains(exercicio.id),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  _exerciciosSelecionados.add(exercicio.id!);
                                } else {
                                  _exerciciosSelecionados.remove(exercicio.id);
                                }
                              });
                            },
                            activeColor: Colors.orangeAccent,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Botão Salvar fixo na parte inferior
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _salvarTreino,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'SALVAR ALTERAÇÕES',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }
}