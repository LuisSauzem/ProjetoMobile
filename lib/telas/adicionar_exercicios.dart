import 'package:flutter/material.dart';
import 'package:projetomobile/models/exercicio_models.dart';
import 'package:projetomobile/service/exercicio_service.dart';

class AdicionarExercicios extends StatelessWidget {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _comofazerController = TextEditingController();
  final TextEditingController _intervaloController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final ExercicioService _exercicioService = ExercicioService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text('NOVO EXERCÍCIO',
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
                  context,
                  controller: _nomeController,
                  label: "NOME DO EXERCÍCIO",
                  icon: Icons.fitness_center,
                  validator: (value) => value?.isEmpty ?? true ? 'Campo obrigatório' : null,
                ),
                SizedBox(height: 20),
                _buildExerciseTextField(
                  context,
                  controller: _comofazerController,
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
                        context,
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
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      ExercicioModel ex = ExercicioModel(
                        nome: _nomeController.text,
                        comoFazer: _comofazerController.text,
                        intervalo: _intervaloController.text,
                        peso: _pesoController.text,
                      );
                      await _exercicioService.addExercicio(ex);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.orangeAccent,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'SALVAR EXERCÍCIO',
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