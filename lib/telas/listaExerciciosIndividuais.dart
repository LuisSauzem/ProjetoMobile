import 'package:flutter/material.dart';
import 'package:projetomobile/service/exercicio_service.dart';
import '../models/exercicio_models.dart';
import 'adicionar_exercicios.dart';
import 'editar_exercicio.dart';

// Tela que lista exercícios individuais
class ListaExerciciosIndividuais extends StatefulWidget {
  const ListaExerciciosIndividuais({super.key});

  @override
  State<ListaExerciciosIndividuais> createState() => _ListaExerciciosIndividuaisState();
}

class _ListaExerciciosIndividuaisState extends State<ListaExerciciosIndividuais> {
  final ExercicioService _exercicioService = ExercicioService();

  // Future que armazenará a lista de exercícios
  late Future<List<ExercicioModel>> _exercicios;

  @override
  void initState() {
    super.initState();
    // Carrega os exercícios quando a tela é iniciada
    _carregarExercicios();
  }

  // Metodo para carregar os exercícios
  Future<void> _carregarExercicios() async {
    setState(() {
      _exercicios = _exercicioService.getExercicios();
    });
  }

  // Metodo para recarregar a lista de exercícios
  void _refreshExercicios() {
    setState(() {
      _exercicios = _exercicioService.getExercicios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212), // Cor de fundo escura
      appBar: AppBar(
        title: Text('MEUS EXERCÍCIOS',
            style: TextStyle(
                fontFamily: 'BebasNeue',
                fontSize: 24,
                letterSpacing: 1.5,
                color: Colors.white)),
        centerTitle: true, // Centraliza o título
        backgroundColor: Colors.black,
        elevation: 0, // Remove sombra da AppBar
        iconTheme: IconThemeData(color: Colors.orangeAccent), // Cor dos ícones
      ),

      // Botão flutuante para adicionar novos exercícios
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navega para a tela de cadastro de exercícios
          final resultado = await Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdicionarExercicios()),
          );

          // Se o exercício foi cadastrado com sucesso (retorno true), atualiza a lista
          if (resultado == true) {
            _refreshExercicios();
          }
        },
        backgroundColor: Colors.orangeAccent, // Cor laranja do botão
        child: Icon(Icons.add, color: Colors.black), // Ícone de adição
      ),

      body: Container(
        decoration: BoxDecoration(
          // Gradiente de fundo
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2A2A2A), // Cinza mais claro no topo
              Color(0xFF121212), // Preto mais escuro na base
            ],
            stops: [0.3, 0.7], // Controla a transição do gradiente
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          // FutureBuilder para lidar com o carregamento assíncrono
          child: FutureBuilder(
            future: _exercicios,
            builder: (context, snapshot) {
              // Mostra um loading enquanto os dados estão sendo carregados
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                        color: Colors.orangeAccent));
              }

              // Mostra mensagem de erro se ocorrer algum problema
              if (snapshot.hasError) {
                return Center(
                    child: Text("Erro ao carregar exercícios",
                        style: TextStyle(color: Colors.white70)));
              }

              // Mostra mensagem se não houver exercícios cadastrados
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fitness_center,
                          size: 48,
                          color: Colors.white70),
                      SizedBox(height: 16),
                      Text("Nenhum exercício cadastrado",
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16
                          )
                      ),
                    ],
                  ),
                );
              }

              // Lista os exercícios quando os dados são carregados com sucesso
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

  // Metodo para construir o card de cada exercício
  Widget _buildExerciseCard(BuildContext context, ExercicioModel ex) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // Gradiente para o card
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF252525),
            Color(0xFF1A1A1A),
          ],
        ),
        // Sombra para efeito de profundidade
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
            // Linha superior com ícone, nome e botões de ação
            Row(
              children: [
                // Ícone do exercício
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
                // Nome do exercício
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
                // Botão de edição
                _buildActionButton(
                  icon: Icons.edit,
                  color: Colors.orangeAccent,
                  onPressed: () async {
                    // Navega para tela de edição e atualiza se houver mudanças
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
                // Botão de exclusão
                _buildActionButton(
                  icon: Icons.delete,
                  color: Colors.redAccent,
                  onPressed: () => _confirmDelete(context, ex),
                ),
              ],
            ),
            // Seção inferior com detalhes do exercício
            Padding(
              padding: const EdgeInsets.only(left: 50, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Chip com informação de peso
                      _buildDetailChip(
                          icon: Icons.scale,
                          label: '${ex.peso} kg',
                          color: Colors.blueAccent),
                      SizedBox(width: 10),
                      // Chip com informação de intervalo
                      _buildDetailChip(
                          icon: Icons.timer,
                          label: '${ex.intervalo} s',
                          color: Colors.greenAccent),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Descrição de como fazer o exercício
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

  // Metodo auxiliar para criar botões de ação
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, size: 22),
      color: color,
      onPressed: onPressed,
      splashRadius: 20,
    );
  }

  // Metodo auxiliar para criar chips de detalhes
  Widget _buildDetailChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Chip(
      backgroundColor: color.withOpacity(0.2),
      label: Text(label,
          style: TextStyle(color: Colors.white, fontSize: 12)),
      avatar: Icon(icon, size: 16, color: color),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  // Metodo para confirmar exclusão de exercício
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
          // Botão de cancelar
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancelar",
                style: TextStyle(color: Colors.orangeAccent)),
          ),
          // Botão de confirmar
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Excluir", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    // Se confirmado, exclui o exercício e atualiza a lista
    if (confirm ?? false) {
      await _exercicioService.deleteExercicio(ex.id!);
      _refreshExercicios();
    }
  }
}