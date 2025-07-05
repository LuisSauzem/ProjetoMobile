import 'package:flutter/material.dart';
import 'package:projetomobile/service/exercicio_service.dart';
import '../models/exercicio_models.dart';
import 'editar_exercicio.dart';

class ListaExerciciosIndividuais extends StatefulWidget {
  const ListaExerciciosIndividuais({super.key});

  @override
  State<ListaExerciciosIndividuais> createState() => _ListaExerciciosIndividuaisState();
}

class _ListaExerciciosIndividuaisState extends State<ListaExerciciosIndividuais> {
  final ExercicioService _exercicioService = ExercicioService();
  late Future<List<ExercicioModel>> _exercicios;

  @override
  void initState() {
    super.initState();
    _exercicios = _exercicioService.getExercicios();
  }

  void _refreshExercicios() {
    setState(() {
      _exercicios = _exercicioService.getExercicios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text('MEUS EXERCÍCIOS',
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
          padding: const EdgeInsets.all(12.0),
          child: FutureBuilder(
            future: _exercicios,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                        color: Colors.orangeAccent));
              }
              if (snapshot.hasError) {
                return Center(
                    child: Text("Erro ao carregar exercícios",
                        style: TextStyle(color: Colors.white70)));
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final ex = snapshot.data![index];
                  return _buildExerciseCard(context, ex);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, ExercicioModel ex) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF252525),
            Color(0xFF1A1A1A),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.fitness_center,
                      size: 24, color: Colors.orangeAccent),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    ex.nome,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                _buildActionButton(
                  icon: Icons.edit,
                  color: Colors.orangeAccent,
                  onPressed: () async {
                    final resultado = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditarExercicio(exercicio: ex),
                      ),
                    );
                    if (resultado == true) {
                      _refreshExercicios();
                    }
                  },
                ),
                SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.delete,
                  color: Colors.redAccent,
                  onPressed: () => _confirmDelete(context, ex),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildDetailChip(
                          icon: Icons.scale,
                          label: '${ex.peso} kg',
                          color: Colors.blueAccent),
                      SizedBox(width: 10),
                      _buildDetailChip(
                          icon: Icons.timer,
                          label: '${ex.intervalo} s',
                          color: Colors.greenAccent),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    ex.comoFazer,
                    style: TextStyle(
                        color: Colors.white70,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      {required IconData icon,
        required Color color,
        required VoidCallback onPressed}) {
    return IconButton(
      icon: Icon(icon, size: 22),
      color: color,
      onPressed: onPressed,
      splashRadius: 20,
    );
  }

  Widget _buildDetailChip(
      {required IconData icon, required String label, required Color color}) {
    return Chip(
      backgroundColor: color.withOpacity(0.2),
      label: Text(label,
          style: TextStyle(color: Colors.white, fontSize: 12)),
      avatar: Icon(icon, size: 16, color: color),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Future<void> _confirmDelete(BuildContext context, ExercicioModel ex) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1E1E1E),
        title: Text("Confirmar exclusão",
            style: TextStyle(color: Colors.white)),
        content: Text("Deseja excluir '${ex.nome}'?",
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar",
                style: TextStyle(color: Colors.orangeAccent)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Excluir", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      await _exercicioService.deleteExercicio(ex.id!);
      _refreshExercicios();
    }
  }
}