import 'package:flutter/material.dart';
import '../models/exercicio_models.dart';
import '../models/treino_models.dart';
import '../service/exercicio_service.dart';
import '../database/treino_dao.dart';

// Tela para cadastro de novos treinos
class CadastroTreino extends StatefulWidget {
  const CadastroTreino({Key? key}) : super(key: key);

  @override
  State<CadastroTreino> createState() => _CadastroTreinoState();
}

class _CadastroTreinoState extends State<CadastroTreino> {
  // Controlador para o campo de nome do treino
  final _nomeController = TextEditingController();

  // Serviço para carregar os exercícios disponíveis
  final _exercicioService = ExercicioService();

  // Lista de todos os exercícios disponíveis
  List<ExercicioModel> _exercicios = [];

  // Conjunto com os IDs dos exercícios selecionados
  Set<int> _selecionados = {};

  @override
  void initState() {
    super.initState();
    // Carrega os exercícios quando a tela é iniciada
    _carregarExercicios();
  }

  // Carrega a lista de exercícios do banco de dados
  Future<void> _carregarExercicios() async {
    final exercicios = await _exercicioService.getExercicios();
    setState(() {
      _exercicios = exercicios;
    });
  }

  // Metodo para salvar o novo treino
  Future<void> _salvarTreino() async {
    // Remove espaços em branco do nome
    final nome = _nomeController.text.trim();

    // Validação do nome
    if (nome.isEmpty) {
      _mostrarSnackBar('Informe o nome do treino');
      return;
    }

    // Validação dos exercícios selecionados
    if (_selecionados.isEmpty) {
      _mostrarSnackBar('Selecione pelo menos um exercício');
      return;
    }

    // Cria o novo objeto de treino
    final novoTreino = TreinoModel(
      nome: nome,
      exercicios: _selecionados.toList(), // Converte Set para List
    );

    // Salva no banco de dados
    await TreinoDao().salvarTreino(novoTreino);

    // Verifica se o widget ainda está montado antes de navegar
    if (!mounted) return;
    Navigator.of(context).pop(); // Fecha a tela de cadastro
  }

  // Mostra uma mensagem temporária na parte inferior da tela
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
      backgroundColor: Color(0xFF121212), // Cor de fundo escura
      appBar: AppBar(
        title: Text('NOVO TREINO',
            style: TextStyle(
                fontFamily: 'BebasNeue',
                fontSize: 24,
                letterSpacing: 1.5,
                color: Colors.white)),
        centerTitle: true, // Centraliza o título
        backgroundColor: Colors.black, // Cor da AppBar
        elevation: 0, // Remove sombra
        iconTheme: IconThemeData(color: Colors.orangeAccent), // Cor dos ícones
      ),
      body: Container(
        decoration: BoxDecoration(
          // Gradiente de fundo
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Campo para inserir o nome do treino
              _buildTextField(
                controller: _nomeController,
                label: 'NOME DO TREINO',
                icon: Icons.playlist_add,
              ),
              SizedBox(height: 20),

              // Título da seção de seleção de exercícios
              Text('SELECIONE OS EXERCÍCIOS',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10),

              // Lista de exercícios disponíveis
              Expanded(
                child: _exercicios.isEmpty
                    ? Center(
                    child: Text('Nenhum exercício cadastrado.',
                        style: TextStyle(color: Colors.white70)))
                    : ListView(
                  children: _exercicios.map((e) {
                    return _buildExerciseItem(e); // Item da lista, construído abaixo.
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),

              // Botão para salvar o treino
              ElevatedButton(
                onPressed: _salvarTreino,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, // Cor do texto
                  backgroundColor: Colors.orangeAccent, // Cor de fundo
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Bordas arredondadas
                  ),
                  elevation: 8, // Sombra
                ),
                child: Row( //com o child, é possível adicionar mais personalização
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save), // Ícone de salvar
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

  // Metodo auxiliar para construir campos de texto padronizados
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white), // Cor do texto
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70), // Cor do label
        prefixIcon: Icon(icon, color: Colors.orangeAccent), // Ícone
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade800), // Borda normal
          borderRadius: BorderRadius.circular(12), // Bordas arredondadas
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orangeAccent), // Borda quando focada
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Color(0xFF1E1E1E), // Cor de fundo do campo
      ),
    );
  }

  // Metodo auxiliar para construir itens da lista de exercícios
  Widget _buildExerciseItem(ExercicioModel exercicio) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6), // Margem vertical
      color: Color(0xFF1E1E1E), // Cor de fundo
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Bordas arredondadas
      ),
      child: CheckboxListTile(
        title: Text(exercicio.nome,
            style: TextStyle(color: Colors.white)), // Nome do exercício
        subtitle: Text('Peso: ${exercicio.peso} kg | Intervalo: ${exercicio.intervalo} s',
            style: TextStyle(color: Colors.white70)), // Detalhes
        secondary: Icon(Icons.fitness_center,
            color: Colors.orangeAccent), // Ícone
        activeColor: Colors.orangeAccent, // Cor quando selecionado
        checkColor: Colors.black, // Cor do checkmark
        value: _selecionados.contains(exercicio.id), // Verifica se está selecionado
        onChanged: (value) {
          setState(() {
            // Adiciona ou remove o exercício da seleção
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