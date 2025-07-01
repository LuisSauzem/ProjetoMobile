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
    print(widget.exercicio.id);
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
          SnackBar(content: Text("Exercício atualizado com sucesso")),
        );
        Navigator.pop(context, true);

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Editar Exercício"), backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: "Nome"),
                validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _comoFazerController,
                decoration: InputDecoration(labelText: "Como fazer"),
                validator: (value) => value!.isEmpty ? 'Informe como fazer' : null,
              ),
              TextFormField(
                controller: _intervaloController,
                decoration: InputDecoration(labelText: "Intervalo (s)"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Informe o intervalo' : null,
              ),
              TextFormField(
                controller: _pesoController,
                decoration: InputDecoration(labelText: "Peso (kg)"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Informe o peso' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvar,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                child: Text("Salvar Alterações",
                  style: TextStyle(
                  color: Colors.white,),
              ),
              ),
            ],

          ),
        ),
      ),
    );
  }
}
