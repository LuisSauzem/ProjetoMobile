import 'package:flutter/material.dart';
import 'package:projetomobile/models/exercicio_models.dart';
import 'package:projetomobile/service/exercicio_service.dart';

class EditarExercicio extends StatefulWidget {
  final ExercicioModel exercicio;

  const EditarExercicio({Key? key, required this.exercicio}) : super(key: key);

  @override
  State<EditarExercicio> createState() => _EditarExercicioState();
}

class _EditarExercicioState extends State<EditarExercicio> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _comoFazerController = TextEditingController();
  final _intervaloController = TextEditingController();
  final _pesoController = TextEditingController();
  final ExercicioService _service = ExercicioService();

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.exercicio.nome;
    _comoFazerController.text = widget.exercicio.comoFazer;
    _intervaloController.text = widget.exercicio.intervalo;
    _pesoController.text = widget.exercicio.peso;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _comoFazerController.dispose();
    _intervaloController.dispose();
    _pesoController.dispose();
    super.dispose();
  }

  void _salvar() async {
    if (_formKey.currentState!.validate()) {
      final atualizado = ExercicioModel(
        id: widget.exercicio.id,
        nome: _nomeController.text,
        comoFazer: _comoFazerController.text,
        intervalo: _intervaloController.text,
        peso: _pesoController.text,
      );

      await _service.updateExercicio(atualizado);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Exercício atualizado com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text('EDITAR EXERCÍCIO',
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
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildExerciseTextField(
                  controller: _nomeController,
                  label: "NOME DO EXERCÍCIO",
                  icon: Icons.fitness_center,
                  validator: (value) => value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                ),
                SizedBox(height: 20),
                _buildExerciseTextField(
                  controller: _comoFazerController,
                  label: "DESCRIÇÃO DO MOVIMENTO",
                  icon: Icons.description,
                  validator: (value) => value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildExerciseTextField(
                        controller: _intervaloController,
                        label: "INTERVALO (s)",
                        icon: Icons.timer,
                        validator: (value) => value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: _buildExerciseTextField(
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
                ElevatedButton(
                  onPressed: _salvar,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.orangeAccent,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
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

  Widget _buildExerciseTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white, fontSize: 16),
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
}