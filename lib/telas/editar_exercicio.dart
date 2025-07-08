import 'package:flutter/material.dart';
import 'package:projetomobile/models/exercicio_models.dart';
import 'package:projetomobile/service/exercicio_service.dart';

// Tela para edição de um exercício existente
class EditarExercicio extends StatefulWidget {
  final ExercicioModel exercicio; // Exercício que será editado

  const EditarExercicio({Key? key, required this.exercicio}) : super(key: key);

  @override
  State<EditarExercicio> createState() => _EditarExercicioState();
}

class _EditarExercicioState extends State<EditarExercicio> {
  // Chave global para o formulário (usada para validação)
  final _formKey = GlobalKey<FormState>();

  // Controladores para os campos do formulário
  final _nomeController = TextEditingController();
  final _comoFazerController = TextEditingController();
  final _intervaloController = TextEditingController();
  final _pesoController = TextEditingController();

  final ExercicioService _service = ExercicioService();

  @override
  void initState() {
    super.initState();
    // Preenche os controladores com os valores atuais do exercício
    _nomeController.text = widget.exercicio.nome;
    _comoFazerController.text = widget.exercicio.comoFazer;
    _intervaloController.text = widget.exercicio.intervalo;
    _pesoController.text = widget.exercicio.peso;
  }

  @override
  void dispose() {
    // Libera os recursos dos controladores quando o widget é destruído
    _nomeController.dispose();
    _comoFazerController.dispose();
    _intervaloController.dispose();
    _pesoController.dispose();
    super.dispose();
  }

  // Metodo para salvar as alterações no exercício
  void _salvar() async {
    // Valida os campos do formulário
    if (_formKey.currentState!.validate()) {
      // Cria um novo objeto com os dados atualizados
      final atualizado = ExercicioModel(
        id: widget.exercicio.id,
        nome: _nomeController.text,
        comoFazer: _comoFazerController.text,
        intervalo: _intervaloController.text,
        peso: _pesoController.text,
      );

      // Chama o serviço para atualizar no banco de dados
      await _service.updateExercicio(atualizado);

      // Verifica se o widget ainda está montado antes de mostrar o SnackBar
      if (context.mounted) {
        // Mostra mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Exercício atualizado com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
        // Retorna à tela anterior com indicador de sucesso
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212), // Cor de fundo escura
      appBar: AppBar(
        title: Text('EDITAR EXERCÍCIO',
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
          child: Form(
            key: _formKey, // Chave do formulário para validação
            child: ListView(
              children: [
                // Campo para editar o nome do exercício
                _buildExercicioTextField(
                  controller: _nomeController,
                  label: "NOME DO EXERCÍCIO",
                  icon: Icons.fitness_center,
                  validator: (value) => value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                ),
                SizedBox(height: 20),

                // Campo para editar a descrição do movimento
                _buildExercicioTextField(
                  controller: _comoFazerController,
                  label: "DESCRIÇÃO DO MOVIMENTO",
                  icon: Icons.description,
                  validator: (value) => value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                  maxLines: 3, // Permite múltiplas linhas
                ),
                SizedBox(height: 20),

                // Linha com campos numéricos
                Row(
                  children: [
                    // Campo para editar o intervalo entre séries
                    Expanded(
                      child: _buildExercicioTextField(
                        controller: _intervaloController,
                        label: "INTERVALO (s)",
                        icon: Icons.timer,
                        validator: (value) => value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                        keyboardType: TextInputType.number, // Teclado numérico
                      ),
                    ),
                    SizedBox(width: 20),

                    // Campo para editar o peso/carga
                    Expanded(
                      child: _buildExercicioTextField(
                        controller: _pesoController,
                        label: "CARGA (kg)",
                        icon: Icons.scale,
                        validator: (value) => value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                        keyboardType: TextInputType.number, // Teclado numérico
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),

                // Botão para salvar as alterações
                ElevatedButton(
                  onPressed: _salvar,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, // Cor do texto
                    backgroundColor: Colors.orangeAccent, // Cor de fundo
                    padding: EdgeInsets.symmetric(vertical: 18), // Espaçamento interno
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Bordas arredondadas
                    ),
                    elevation: 8, // Sombra do botão
                  ),
                  child: Text(
                    'SALVAR ALTERAÇÕES',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.8,
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
  Widget _buildExercicioTextField({
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
          borderSide: BorderSide(color: Colors.grey.shade800), // Borda quando não focada
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