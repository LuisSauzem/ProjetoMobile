import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Gym',
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> ListaDeTreinos = ['Treino A', 'Treino B','Treino C', 'Treino D', 'Treino E'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Exercícios'),
      ),
      body: ListView.builder(
        itemCount: ListaDeTreinos.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ListaDeTreinos[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.play_circle_outline_sharp),
                  onPressed: (){},
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
