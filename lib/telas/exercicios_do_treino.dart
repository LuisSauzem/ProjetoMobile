import 'package:flutter/material.dart';
import '../models/treino_models.dart';
import '../models/exercicio_models.dart';
import '../database/exercicio_dao.dart';
import 'listaTreinos.dart';

// Tela que mostra os exercícios de um treino específico
class ExerciciosDoTreino extends StatefulWidget {
  final TreinoModel treino; // Recebe o treino como parâmetro

  const ExerciciosDoTreino({Key? key, required this.treino}) : super(key: key);

  @override
  State<ExerciciosDoTreino> createState() => _ExerciciosDoTreinoState();
}

class _ExerciciosDoTreinoState extends State<ExerciciosDoTreino> {
  final ExercicioDao _exercicioDao = ExercicioDao(); // DAO para acesso aos exercícios
  List<ExercicioModel> _exercicios = []; // Lista de exercícios do treino
  bool _isLoading = true; // Controla o estado de carregamento

  @override
  void initState() {
    super.initState();
    _carregarExercicios(); // Carrega os exercícios quando a tela é iniciada
  }

  // Carrega os exercícios do treino atual
  Future<void> _carregarExercicios() async {
    try {
      final todosExercicios = await _exercicioDao.getAllExercicios();
      setState(() {
        // Filtra apenas os exercícios que pertencem a este treino
        _exercicios = todosExercicios
            .where((e) => widget.treino.exercicios.contains(e.id))
            .toList();
        _isLoading = false; // Finaliza o carregamento
      });
    } catch (e) { //para tratar algum erro ao carregar os treinos
      setState(() => _isLoading = false);
      // Mostra mensagem de erro se algo falhar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar exercícios: ${e.toString()}')),
      );
    }
  }

  // Diálogo para confirmar finalização do treino
  Future<void> _finalizarTreino() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Finalizar treino?',
            style: TextStyle(color: Colors.white)),
        content: const Text('Deseja marcar este treino como concluído?',
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.orangeAccent)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirmar', style: TextStyle(color: Colors.orangeAccent)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      // Simula um tempo de processamento
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        // Volta para a lista de treinos após finalizar
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ListaTreinos()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(widget.treino.nome.toUpperCase(),
            style: const TextStyle(
                fontFamily: 'BebasNeue',
                fontSize: 24,
                letterSpacing: 1.5,
                color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.orangeAccent),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2A2A2A),  // Cinza mais claro no topo
              Color(0xFF121212),  // Preto mais escuro na base
            ],
            stops: [0.3, 0.7],  // Controla a transição do gradiente
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.orangeAccent))
                  : _exercicios.isEmpty
                  ? const Center(
                child: Text('Nenhum exercício neste treino',
                    style: TextStyle(color: Colors.white70)),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _exercicios.length,
                itemBuilder: (context, index) {
                  final exercicio = _exercicios[index];
                  return _buildExerciseCard(exercicio); // Cria um card para cada exercício
                },
              ),
            ),
            // Botão para finalizar o treino
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _finalizarTreino,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                    'FINALIZAR TREINO',
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

  // Cria um card visual para cada exercício
  Widget _buildExerciseCard(ExercicioModel exercicio) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome do exercício
            Text(
              exercicio.nome,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Chips com informações do exercício
            Row(
              children: [
                _buildDetailChip(
                  icon: Icons.fitness_center,
                  label: '${exercicio.peso} kg',
                ),
                const SizedBox(width: 8),
                _buildDetailChip(
                  icon: Icons.timer,
                  label: '${exercicio.intervalo} s',
                ),
              ],
            ),
            // Descrição de como fazer o exercício (se existir)
            if (exercicio.comoFazer.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                exercicio.comoFazer,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para criar chips de detalhes
  Widget _buildDetailChip({required IconData icon, required String label}) {
    return Chip(
      backgroundColor: Colors.orangeAccent.withOpacity(0.2),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      avatar: Icon(icon, size: 18, color: Colors.orangeAccent),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}