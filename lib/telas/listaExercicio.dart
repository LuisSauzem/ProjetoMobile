import 'package:flutter/material.dart';
import '../models/treino_models.dart';

class ListaExercicio extends StatelessWidget {
  final Treino treino;

  ListaExercicio({required this.treino});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(treino.nome),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: treino.listaExercicio.length,
          itemBuilder: (context, index) {
            final exercicio = treino.listaExercicio[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurpleAccent,
                  child: Icon(Icons.fitness_center, color: Colors.white),
                ),
                title: Text(
                  exercicio.nome,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exercicio.comoFazer),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.timer, size: 16, color: Colors.grey[700]),
                          SizedBox(width: 4),
                          Text('${exercicio.intervalo}s'),
                          SizedBox(width: 16),
                          Icon(Icons.fitness_center, size: 16, color: Colors.grey[700]),
                          SizedBox(width: 4),
                          Text('${exercicio.peso} kg'),
                        ],
                      ),
                    ],
                  ),
                ),

                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
