import 'package:flutter/material.dart';
import 'package:projetomobile/telas/listaTreinos.dart';

void main() {
  runApp(MaterialApp(
    title: 'Gym',
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    home: Login(),
  ));
}
class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela de Login'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: ElevatedButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => listaTreinos()
          ));
        },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 25.0),
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0)),
            backgroundColor: Colors.deepPurple,
          ),
            child: Text('LOGIN', style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
            ),
        ),
      ),
    );
  }
}

