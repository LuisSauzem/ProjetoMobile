import 'package:flutter/material.dart';
import '../models/exercicio_models.dart';

class ListaExerciciosIndividuais extends StatelessWidget {
  final List<ExercicioModel> exercicios;

  const ListaExerciciosIndividuais({Key? key, required this.exercicios}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercícios'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: exercicios.length,
          itemBuilder: (context, index) {
            final ex = exercicios[index];

            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.fitness_center, color: Colors.white),
                ),
                title: Text(
                  ex.nome,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Peso: ${ex.peso} kg'),
                      Text('Intervalo: ${ex.intervalo} s'),
                      SizedBox(height: 6),
                      Text(
                        ex.comoFazer,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
