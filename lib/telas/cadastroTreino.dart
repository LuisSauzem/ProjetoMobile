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
    if (nome.isEmpty) {
      _mostrarSnackBar('Informe o nome do treino');
      return;
    }
    if (_selecionados.isEmpty) {
      _mostrarSnackBar('Selecione pelo menos um exercício');
      return;
    }

    final novoTreino = TreinoModel(
      nome: nome,
      exercicios: _selecionados.toList(),
    );

    await TreinoDao().salvarTreino(novoTreino);

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void _mostrarSnackBar(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text('NOVO TREINO',
            style: TextStyle(
                fontFamily: 'BebasNeue',
                fontSize: 24,
                letterSpacing: 1.5,
                color: Colors.white)),
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildTextField(
                controller: _nomeController,
                label: 'NOME DO TREINO',
                icon: Icons.playlist_add,
              ),
              SizedBox(height: 20),
              Text('SELECIONE OS EXERCÍCIOS',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Expanded(
                child: _exercicios.isEmpty
                    ? Center(
                    child: Text('Nenhum exercício cadastrado.',
                        style: TextStyle(color: Colors.white70)))
                    : ListView(
                  children: _exercicios.map((e) {
                    return _buildExerciseItem(e);
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarTreino,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.orangeAccent,
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save),
                    SizedBox(width: 10),
                    Text('SALVAR TREINO',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.8)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.orangeAccent),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade800),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orangeAccent),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Color(0xFF1E1E1E),
      ),
    );
  }

  Widget _buildExerciseItem(ExercicioModel exercicio) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      color: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: CheckboxListTile(
        title: Text(exercicio.nome,
            style: TextStyle(color: Colors.white)),
        subtitle: Text('Peso: ${exercicio.peso} kg | Intervalo: ${exercicio.intervalo} s',
            style: TextStyle(color: Colors.white70)),
        secondary: Icon(Icons.fitness_center,
            color: Colors.orangeAccent),
        activeColor: Colors.orangeAccent,
        checkColor: Colors.black,
        value: _selecionados.contains(exercicio.id),
        onChanged: (value) {
          setState(() {
            if (value == true) {
              _selecionados.add(exercicio.id!);
            } else {
              _selecionados.remove(exercicio.id);
            }
          });
        },
      ),
    );
  }
}