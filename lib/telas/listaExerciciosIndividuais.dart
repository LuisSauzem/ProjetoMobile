import 'package:flutter/material.dart';
import 'package:projetomobile/service/exercicio_service.dart';
import '../models/exercicio_models.dart';
import 'editar_exercicio.dart';

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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange),
                            onPressed: () async {
                              final resultado = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) => EditarExercicio(exercicio: ex),
                                ),
                              );
                              if (resultado == true) {
                              _refreshExercicios(); //
                              }
                            },

                              ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Confirmar exclusão"),
                                content: Text("Deseja realmente excluir o exercício '${ex.nome}'?"),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancelar")),
                                  TextButton(onPressed: () => Navigator.pop(context, true), child: Text("Excluir")),
                                  ],
                                ),
                            );
                              if (confirm ?? false) {
                                await _exercicioService.deleteExercicio(ex.id!);
                                  _refreshExercicios();
                              }
                          },

                        ),
                      ],
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
