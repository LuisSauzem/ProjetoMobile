import 'package:flutter/material.dart';
import 'package:projetomobile/models/exercicio_models.dart';
import 'package:projetomobile/service/exercicio_service.dart';

import 'listaExerciciosIndividuais.dart';

// Tela para adicionar novos exercícios (StatelessWidget)
class AdicionarExercicios extends StatefulWidget {
  @override
  _AdicionarExerciciosState createState() => _AdicionarExerciciosState();
}

class _AdicionarExerciciosState extends State<AdicionarExercicios> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _comofazerController = TextEditingController();
  final TextEditingController _intervaloController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ExercicioService _exercicioService = ExercicioService();

  @override
  void dispose() {
    // Limpa os controladores quando o widget for destruído
    _nomeController.dispose();
    _comofazerController.dispose();
    _intervaloController.dispose();
    _pesoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212), // Cor de fundo escura
      appBar: AppBar(
        title: Text('NOVO EXERCÍCIO',
            style: TextStyle(
                fontFamily: 'BebasNeue', // Fonte personalizada
                fontSize: 24,
                letterSpacing: 1.5, // Espaçamento entre letras
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
          child: Form(
            key: _formKey, // Chave do formulário para validação
            child: ListView(
              children: [
                // Campo para o nome do exercício
                _buildExerciseTextField(
                  context,
                  controller: _nomeController,
                  label: "NOME DO EXERCÍCIO",
                  icon: Icons.fitness_center,
                  validator: (value) => value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                ),
                SizedBox(height: 20), // Espaçamento

                // Campo para a descrição do movimento
                _buildExerciseTextField(
                  context,
                  controller: _comofazerController,
                  label: "DESCRIÇÃO DO EXERCÍCIO",
                  icon: Icons.description,
                  validator: (value) => value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                  maxLines: 3, // Permite múltiplas linhas
                ),
                SizedBox(height: 20),

                // Linha com campos numéricos
                Row(
                  children: [
                    // Campo para o intervalo entre séries
                    Expanded(
                      child: _buildExerciseTextField(
                        context,
                        controller: _intervaloController,
                        label: "INTERVALO (s)",
                        icon: Icons.timer,
                        validator: (value) => value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                        keyboardType: TextInputType.number, // Teclado numérico
                      ),
                    ),
                    SizedBox(width: 20), // Espaçamento entre campos

                    // Campo para o peso/carga
                    Expanded(
                      child: _buildExerciseTextField(
                        context,
                        controller: _pesoController,
                        label: "CARGA (kg)",
                        icon: Icons.scale,
                        validator: (value) => value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),

                // Botão para salvar o exercício
                ElevatedButton(
                  onPressed: () async {
                    // Valida o formulário antes de salvar
                    if (_formKey.currentState!.validate()) {
                      // Cria novo objeto de exercício
                      ExercicioModel ex = ExercicioModel(
                        nome: _nomeController.text,
                        comoFazer: _comofazerController.text,
                        intervalo: _intervaloController.text,
                        peso: _pesoController.text,
                      );

                      // Adiciona o exercício via serviço
                      await _exercicioService.addExercicio(ex);

                      // vai para a tela de lista de exercicios individuais
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ListaExerciciosIndividuais()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, // Cor do texto
                    backgroundColor: Colors.orangeAccent, // Cor de fundo
                    padding: EdgeInsets.symmetric(vertical: 18), // Espaçamento interno
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Bordas arredondadas
                    ),
                  ),
                  child: Text(
                    'SALVAR EXERCÍCIO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Texto em negrito
                      fontSize: 16,
                      letterSpacing: 0.8, // Espaçamento entre letras
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Metodo auxiliar para construir campos de texto padronizados
  Widget _buildExerciseTextField(
      BuildContext context, {
        required TextEditingController controller,
        required String label,
        required IconData icon,
        required String? Function(String?)? validator,
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return TextFormField(
      controller: controller,
      validator: validator, // Função de validação
      maxLines: maxLines, // Número de linhas
      keyboardType: keyboardType, // Tipo de teclado
      style: TextStyle(color: Colors.white, fontSize: 16), // Estilo do texto
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70), // Estilo do label
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
}