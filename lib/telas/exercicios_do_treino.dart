import 'package:flutter/material.dart';
import '../models/treino_models.dart';
import '../models/exercicio_models.dart';
import '../database/exercicio_dao.dart';
import 'listaTreinos.dart';

class ExerciciosDoTreino extends StatefulWidget {
  final TreinoModel treino;

  const ExerciciosDoTreino({Key? key, required this.treino}) : super(key: key);

  @override
  State<ExerciciosDoTreino> createState() => _ExerciciosDoTreinoState();
}

class _ExerciciosDoTreinoState extends State<ExerciciosDoTreino> {
  final ExercicioDao _exercicioDao = ExercicioDao();
  List<ExercicioModel> _exercicios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarExercicios();
  }

  Future<void> _carregarExercicios() async {
    try {
      final todosExercicios = await _exercicioDao.getAllExercicios();
      setState(() {
        _exercicios = todosExercicios
            .where((e) => widget.treino.exercicios.contains(e.id))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar exercícios: ${e.toString()}')),
      );
    }
  }

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
      await Future.delayed(const Duration(milliseconds: 300)); // Simula operação
      if (mounted) {
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
              Color(0xFF1A1A1A),
              Color(0xFF121212),
            ],
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
                  return _buildExerciseCard(exercicio);
                },
              ),
            ),
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
            Text(
              exercicio.nome,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
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