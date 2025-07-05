import 'package:flutter/material.dart';
import 'package:projetomobile/models/exercicio_models.dart';
import 'package:projetomobile/models/treino_models.dart';
import 'package:projetomobile/database/exercicio_dao.dart';
import 'package:projetomobile/database/treino_dao.dart';
import 'package:projetomobile/telas/cadastroTreino.dart';
import 'package:projetomobile/telas/editar_treino.dart';
import 'package:projetomobile/telas/exercicios_do_treino.dart';

// Tela que lista todos os treinos cadastrados
class ListaTreinos extends StatefulWidget {
  const ListaTreinos({Key? key}) : super(key: key);

  @override
  State<ListaTreinos> createState() => _ListaTreinosState();
}

class _ListaTreinosState extends State<ListaTreinos> {
  // Controladores para acesso ao banco de dados
  final TreinoDao _treinoDao = TreinoDao(); // Para operações com treinos
  final ExercicioDao _exercicioDao = ExercicioDao(); // Para operações com exercícios

  // Variáveis de estado
  List<TreinoModel> _treinos = []; // Armazena a lista de treinos
  bool _isLoading = true; // Indica se os dados estão sendo carregados

  @override
  void initState() {
    super.initState();
    _carregarTreinos(); // Carrega os treinos quando a tela é iniciada
  }

  // Carrega a lista de treinos do banco de dados
  Future<void> _carregarTreinos() async {
    setState(() => _isLoading = true); // Ativa o indicador de carregamento
    _treinos = await _treinoDao.listarTreinos(); // Busca os treinos
    setState(() => _isLoading = false); // Desativa o carregamento
  }

  // Mostra um diálogo de confirmação antes de excluir um treino
  Future<void> _confirmarExclusao(TreinoModel treino) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1E1E1E), // Cor de fundo escura
        title: Text('Excluir Treino', style: TextStyle(color: Colors.white)),
        content: Text('Deseja realmente excluir ${treino.nome}?',
            style: TextStyle(color: Colors.white70)),
        actions: [
          // Botão de cancelar
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar', style: TextStyle(color: Colors.orangeAccent)),
          ),
          // Botão de confirmar exclusão
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Excluir', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    // Se o usuário confirmou, exclui o treino
    if (confirm == true) {
      await _treinoDao.deletarTreino(treino.id!);
      _carregarTreinos(); // Recarrega a lista após exclusão
    }
  }

  // Carrega os exercícios associados a um treino específico
  Future<List<ExercicioModel>> _carregarExerciciosDoTreino(TreinoModel treino) async {
    return await _exercicioDao.getAllExercicios().then((exercicios) {
      // Filtra apenas os exercícios que estão neste treino
      return exercicios.where((e) => treino.exercicios.contains(e.id)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212), // Cor de fundo escura
      appBar: AppBar(
        title: Text('MEUS TREINOS', style: TextStyle(
          fontFamily: 'BebasNeue',
          fontSize: 24,
          letterSpacing: 1.5,
          color: Colors.white,
        )),
        centerTitle: true,
        backgroundColor: Colors.black, // AppBar preta
        iconTheme: IconThemeData(color: Colors.orangeAccent), // Ícones laranja
      ),

      // Botão flutuante para adicionar novos treinos
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CadastroTreino()),
          );
          _carregarTreinos(); // Recarrega a lista após cadastrar
        },
        backgroundColor: Colors.orangeAccent, // Botão laranja
        child: Icon(Icons.add, color: Colors.black),
      ),

      // Corpo da tela
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.orangeAccent))
          : _treinos.isEmpty
          ? Center(child: Text('Nenhum treino cadastrado',
          style: TextStyle(color: Colors.white70)))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _treinos.length,
          itemBuilder: (context, index) {
            final treino = _treinos[index];
            return _buildCardTreino(treino); // Cria um card para cada treino
          },
        ),
      ),
    );
  }

  // Cria um card visual para cada treino
  Widget _buildCardTreino(TreinoModel treino) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      color: Color(0xFF1E1E1E), // Card escuro
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Bordas arredondadas
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExerciciosDoTreino(treino: treino), // Abre tela de exercícios
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho do card com nome e botões
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Nome do treino
                  Text(treino.nome,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  // Botões de editar e excluir
                  Row(
                    children: [
                      // Botão de edição
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.orangeAccent),
                        onPressed: () async {
                          final atualizado = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditarTreinoScreen(treino: treino),
                            ),
                          );
                          if (atualizado == true) {
                            _carregarTreinos(); // Atualiza se houve mudanças
                          }
                        },
                      ),
                      // Botão de exclusão
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => _confirmarExclusao(treino),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Lista de exercícios do treino (carregada assincronamente)
              FutureBuilder<List<ExercicioModel>>(
                future: _carregarExerciciosDoTreino(treino),
                builder: (context, snapshot) {
                  // Mostra indicador enquanto carrega
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LinearProgressIndicator(
                        minHeight: 2,
                        backgroundColor: Colors.grey[800],
                        color: Colors.orangeAccent);
                  }
                  // Mensagem se não tiver exercícios
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('Nenhum exercício neste treino',
                        style: TextStyle(color: Colors.white70));
                  }
                  // Mostra os exercícios como "chips" (etiquetas)
                  return Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: snapshot.data!.map((exercicio) => Chip(
                      label: Text(exercicio.nome),
                      backgroundColor: Colors.orangeAccent.withOpacity(0.2),
                    )).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}