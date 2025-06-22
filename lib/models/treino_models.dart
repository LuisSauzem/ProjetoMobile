import 'dart:convert';

class TreinoModel {
  int? id;
  String nome;
  List<int> exercicios;

  TreinoModel({
    this.id,
    required this.nome,
    required this.exercicios,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'exercicios': jsonEncode(exercicios),
  };

  factory TreinoModel.fromMap(Map<String, dynamic> map) => TreinoModel(
    id: map['id'],
    nome: map['nome'],
    exercicios: (jsonDecode(map['exercicios']) as List).cast<int>(),
  );
}
