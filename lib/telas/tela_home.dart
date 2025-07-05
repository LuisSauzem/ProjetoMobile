import 'package:flutter/material.dart';
import 'package:projetomobile/telas/adicionar_exercicios.dart';
import 'package:projetomobile/telas/listaTreinos.dart';
import 'package:projetomobile/telas/listaExerciciosIndividuais.dart';
import 'cadastroTreino.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text('GYMPRO', style: TextStyle(
            fontFamily: 'BebasNeue',
            fontSize: 28,
            letterSpacing: 1.5)),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0, // Remove sombra da AppBar
        actions: [
          // Botão de perfil (ainda sem funcionalidade)
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.orangeAccent),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          // Gradiente para efeito visual no fundo
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A1A),
              Color(0xFF121212),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.count(   //widget que organiza itens em grade
            crossAxisCount: 2, // 2 cards por linha
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.0, // Cards quadrados
            children: [
              // Cards de ação - cada um abre uma tela diferente
              _buildActionCard( //função criada abaixo para estruturas os cards
                context,
                icon: Icons.add_circle_outline,
                title: 'NOVO EXERCÍCIO',
                subtitle: 'Crie movimentos',
                color: Colors.blueAccent,
                destination: AdicionarExercicios(),
              ),
              _buildActionCard(
                context,
                icon: Icons.fitness_center,
                title: 'EXERCÍCIOS',
                subtitle: 'Todos os exercícios',
                color: Colors.greenAccent,
                destination: ListaExerciciosIndividuais(),
              ),
              _buildActionCard(
                context,
                icon: Icons.playlist_add,
                title: 'NOVO TREINO',
                subtitle: 'Monte seu treino',
                color: Colors.purpleAccent,
                destination: CadastroTreino(),
              ),
              _buildActionCard(
                context,
                icon: Icons.list_alt,
                title: 'TREINOS',
                subtitle: 'Seus treinos',
                color: Colors.orangeAccent,
                destination: ListaTreinos(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, //retuna um card
      {required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
        required Widget destination}) {
    return Card(
      elevation: 8, // Sombra mais pronunciada
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Color(0xFF1E1E1E), // Cor escura do card
      child: InkWell(           //adiciona efeitos de toque
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // Navega para a tela especificada
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Círculo com ícone
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2), // Fundo semitransparente
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: color),
              ),
              SizedBox(height: 15),
              Text(title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(subtitle,
                  style: TextStyle(
                      color: Colors.white70, // Texto secundário mais claro
                      fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}