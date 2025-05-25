import 'package:flutter/material.dart';
import '../models/treino_models.dart';
import 'listaExercicio.dart';

void main() {
  runApp(MaterialApp(
    title: 'Gym',
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Treino> listadetreinos = Treino.lista();

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Treinos'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: listadetreinos.length,
          itemBuilder: (context, index) {
            final treino = listadetreinos[index];
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
                  child: Icon(Icons.directions_run, color: Colors.white),
                ),
                title: Text(
                  treino.nome,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  '${treino.listaExercicio.length} exercícios',
                  style: TextStyle(fontSize: 14),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ListaExercicio(treino: treino),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
