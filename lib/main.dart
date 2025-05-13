import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Vários Textos no Container',
    home: MyHomePage(),
  ));
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Exemplo de dados para a lista (pode ser dinâmico, se necessário)
    List<String> items = ['Treino A', 'Treino B'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Containers'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Margem entre os containers
            padding: EdgeInsets.all(16.0), // Padding interno do container
            decoration: BoxDecoration(
              color: Colors.blueAccent, // Cor do fundo do container
              borderRadius: BorderRadius.circular(12.0), // Bordas arredondadas
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Alinha os textos à esquerda
              children: [
                Text(
                  'Texto acima do item ${items[index]}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8), // Espaço entre os textos
                Text(
                  'Este é um outro texto que pode ser colocado dentro do container.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Outro exemplo de texto no item ${items[index]}!',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
