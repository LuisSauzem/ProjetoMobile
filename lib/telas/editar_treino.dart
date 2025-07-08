import 'package:flutter/material.dart';
import 'package:projetomobile/models/exercicio_models.dart';
import 'package:projetomobile/models/treino_models.dart';
import 'package:projetomobile/database/exercicio_dao.dart';
import 'package:projetomobile/database/treino_dao.dart';

// Tela para edição de um treino existente
class EditarTreinoScreen extends StatefulWidget {
  final TreinoModel treino; // Treino que será editado

  const EditarTreinoScreen({Key? key, required this.treino}) : super(key: key);

  @override
  _EditarTreinoScreenState createState() => _EditarTreinoScreenState();
}

class _EditarTreinoScreenState extends State<EditarTreinoScreen> {
  late TextEditingController _nomeController;

  // Lista de todos os exercícios disponíveis
  late List<ExercicioModel> _todosExercicios;

  // Conjunto com os IDs dos exercícios selecionados
  late Set<int> _exerciciosSelecionados;

  final _exercicioDao = ExercicioDao();
  final _treinoDao = TreinoDao();

  // Controla o estado de carregamento
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Inicializa o controlador com o nome atual do treino
    _nomeController = TextEditingController(text: widget.treino.nome);

    // Converte a lista de exercícios do treino para um Set para que nao occorra duplicações
    //ideal para checkbox
    _exerciciosSelecionados = widget.treino.exercicios.toSet();

    // Carrega a lista de exercícios
    _carregarExercicios();
  }

  // Carrega todos os exercícios do banco de dados
  Future<void> _carregarExercicios() async {
    _todosExercicios = await _exercicioDao.getAllExercicios();
    setState(() => _isLoading = false); // Finaliza o carregamento
  }

  // Salva as alterações no treino
  Future<void> _salvarTreino() async {
    // Valida se o nome foi preenchido
    if (_nomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, insira um nome para o treino'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Cria o objeto do treino atualizado
    final treinoAtualizado = TreinoModel(
      id: widget.treino.id,
      nome: _nomeController.text,
      exercicios: _exerciciosSelecionados.toList(), // Converte Set para List
    );

    // Salva no banco de dados
    await _treinoDao.salvarTreino(treinoAtualizado);

    // Retorna true indicando que o treino foi atualizado
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212), // Cor de fundo escura
      appBar: AppBar(
        title: Text('EDITAR TREINO', style: TextStyle(
          fontFamily: 'BebasNeue',
          fontSize: 24,
          letterSpacing: 1.5,
          color: Colors.white,
        )),
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
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Campo para editar o nome do treino
                    TextField(
                      controller: _nomeController,
                      decoration: InputDecoration(
                        labelText: 'Nome do Treino',
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Color(0xFF1E1E1E), // Cor do campo
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),

                    // Título da seção de exercícios
                    Text('Selecione os exercícios:', style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                    SizedBox(height: 10),

                    // Lista de exercícios selecionáveis
                    Expanded(
                      child: _isLoading
                          ? Center(child: CircularProgressIndicator(color: Colors.orangeAccent))
                      //progesso circular enquanto carrega
                          : ListView.builder( //se falso(ja carregou), mostra a seguir:
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
                            activeColor: Colors.orangeAccent, // Cor do checkbox quando selecionado
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
                    backgroundColor: Colors.orangeAccent, // Cor de fundo laranja
                    foregroundColor: Colors.black, // Cor do texto
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Bordas arredondadas
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
    _nomeController.dispose(); // Libera os recursos do controlador
    super.dispose();
  }
}