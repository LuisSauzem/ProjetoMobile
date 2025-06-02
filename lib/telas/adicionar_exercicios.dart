import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projetomobile/models/exercicio_models.dart';

class AdicionarExercicios extends StatelessWidget {

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _comofazerController = TextEditingController();
  final TextEditingController _intervaloController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Exercício'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              validator: (value){
                if (value == null || value.isEmpty){
                  return 'Nome do Exercício Obrigatório';
                }
                return null;
              },
            controller: this._nomeController,
            decoration: InputDecoration(
              labelText: "Nome do Exercício"
            ),
            style: TextStyle(fontSize: 24),
            ),
            TextFormField(
              validator: (value){
                if (value == null || value.isEmpty){
                  return 'Descrição Obrigatória';
                }
                return null;
              },
              controller: this._comofazerController,
              decoration: InputDecoration(
                  labelText: "Como fazer o Exercício"
              ),
              style: TextStyle(fontSize: 24),
            ),
            TextFormField(
              validator: (value){
                if (value == null || value.isEmpty){
                  return 'Intervalo Obrigatório';
                }
                return null;
              },
              controller: this._intervaloController,
              decoration: InputDecoration(
                  labelText: "Intervalo"
              ),
              style: TextStyle(fontSize: 24),
            ),
            TextFormField(
              validator: (value){
                if (value == null || value.isEmpty){
                  return 'Peso Obrigatório';
                }
                return null;
              },
              controller: this._pesoController,
              decoration: InputDecoration(
                  labelText: "Peso"
              ),
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
                onPressed:(){
                  if(_formKey.currentState!.validate()) {
                    ExercicioModel e = new ExercicioModel(nome: this._nomeController.text,
                        comoFazer: this._comofazerController.text,
                        intervalo: this._intervaloController.text,
                        peso: this._pesoController.text);

                    Navigator.of(context).pop();
                  }else{
                    debugPrint('formulário inválido!');
                  }
                },
                child: Text('SALVAR')),
          ],
        ),
      )
    );
  }
}
