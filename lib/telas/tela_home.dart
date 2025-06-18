import 'package:flutter/material.dart';
import 'package:projetomobile/telas/adicionar_exercicios.dart';
import 'package:projetomobile/telas/listaTreinos.dart';
import 'package:projetomobile/telas/listaExerciciosIndividuais.dart';

import '../models/treino_models.dart';
import 'listaExerciciosIndividuais.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Inicial'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // centraliza verticalmente
          crossAxisAlignment: CrossAxisAlignment.stretch, // faz os botões ocuparem a largura total
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => listaTreinos()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text(
                'Lista de Treinos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AdicionarExercicios()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text(
                'Criar Exercício',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                //  final treinos = Treino.lista();
                //  final todosExercicios = treinos.expand((t) => t.listaExercicio).toList();

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ListaExerciciosIndividuais(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text(
                'Lista de Exercícios',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
