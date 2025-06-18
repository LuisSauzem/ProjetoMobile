import 'package:flutter/material.dart';
import 'package:projetomobile/service/exercicio_service.dart';
import '../models/exercicio_models.dart';

class ListaExerciciosIndividuais extends StatefulWidget {
  const ListaExerciciosIndividuais({super.key});

  @override
  State<ListaExerciciosIndividuais> createState() => _ListaExerciciosIndividuaisState();
}

class _ListaExerciciosIndividuaisState extends State<ListaExerciciosIndividuais> {
  final ExercicioService _exercicioService = ExercicioService();
  late Future<List<ExercicioModel>> _exercicios;




  @override
  void initState() {
    super.initState();
    _exercicios = _exercicioService.getExercicios();
    print("Aqui");
    print(_exercicios);
  }

  void _refreshExercicios(){
    setState(() {
      _exercicios = _exercicioService.getExercicios();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercícios'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child:  FutureBuilder(future: _exercicios,
            builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("erro"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final ex = snapshot.data![index];
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
            );},
        )
      ),
    );
  }
}
