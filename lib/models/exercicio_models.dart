class ExercicioModel {
  int? id;
  String nome;
  String comoFazer;
  String intervalo;
  String peso;

  ExercicioModel({
    required this.nome,
    required this.comoFazer,
    required this.intervalo,
    required this.peso, int? id,
  });


  ExercicioModel.fromMap(Map<String, dynamic> map):
       id = map["id"],
       nome = map["nome"],
       comoFazer = map["comoFazer"],
       intervalo = map["intervalo"],
       peso = map["peso"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nome": nome,
      "comoFazer": comoFazer,
      "intervalo": intervalo,
      "peso": peso,
    };
  }
}
