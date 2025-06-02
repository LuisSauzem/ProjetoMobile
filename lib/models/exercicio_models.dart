class ExercicioModel {
  String nome;
  String comoFazer;
  String intervalo;
  String peso;

  ExercicioModel({
    required this.nome,
    required this.comoFazer,
    required this.intervalo,
    required this.peso,
  });

  ExercicioModel.fromMap(Map<String, dynamic> map):
       nome = map["nome"],
       comoFazer = map["comoFazer"],
       intervalo = map["intervalo"],
       peso = map["peso"];

  Map<String, dynamic> toMap() {
    return {
      "nome": nome,
      "comoFazer": comoFazer,
      "intervalo": intervalo,
      "peso": peso,
    };
  }
}
