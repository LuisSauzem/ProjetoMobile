import 'package:flutter/material.dart';
import 'package:projetomobile/telas/tela_home.dart';

class LoginScreen extends StatelessWidget {
  // Controladores para capturar os dados dos campos de texto
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212), // Fundo escuro (tema dark)
      body: Center(
        child: SingleChildScrollView( // Permite rolagem em telas pequenas
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone e título do app
              Icon(Icons.fitness_center, size: 80, color: Colors.orangeAccent),
              SizedBox(height: 30),
              Text('GYMPRO', style: TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 36,
                  color: Colors.white,
                  letterSpacing: 1.5)),

              SizedBox(height: 40),

              // Campo de Email
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.orangeAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    // Estilização personalizada para estados do campo
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade800)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orangeAccent)),
                    fillColor: Color(0xFF1E1E1E), // Cor de fundo do campo
                    filled: true,
                  ),
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),

              SizedBox(height: 20),

              // Campo de Senha (com obscureText para esconder caracteres)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _senhaController,
                  obscureText: true, // Ativa o modo "password"
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock, color: Colors.orangeAccent),
                    // Mesma estilização do campo de email para consistência
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade800)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orangeAccent)),
                    fillColor: Color(0xFF1E1E1E),
                    filled: true,
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),

              SizedBox(height: 30),

              // Botão de Login com validação básica
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Validação simples: verifica se email não está vazio e contém '@'
                    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Por favor, insira um email válido'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      // Navega para a tela principal (sem verificação de senha)
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => TelaInicial()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent, // Cor do botão
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('ENTRAR', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}