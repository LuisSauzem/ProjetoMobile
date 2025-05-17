class ExercicioModel{
  String id;
  String nome;
  String treino;
  String comoFazer;

  ExercicioModel({
    required this.id,
    required this.nome,
    required this.treino,
    required this.comoFazer,
  });

  ExercicioModel.fromMap(Map<String, dynamic> map):
        id = map["id"],
        nome = map["nome"],
        treino = map["treino"],
        comoFazer = map["comoFazer"];

  Map<String, dynamic> toMap(){
    return{
      "id": id,
      "nome": nome,
      "treino": treino,
      "comoFazer": comoFazer,
    };
  }
}