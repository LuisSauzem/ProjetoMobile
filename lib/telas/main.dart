import 'package:flutter/material.dart';
import 'package:projetomobile/telas/loginScreen.dart';

import '../database/appDatabase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase().database; // Inicializa o banco de dados

  runApp(const GymProApp());
}


class GymProApp extends StatelessWidget {
  const GymProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymPro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        colorScheme: ColorScheme.dark(
          primary: Colors.black,
          secondary: Colors.orangeAccent,
          surface: Color(0xFF1A1A1A),
        ),
        scaffoldBackgroundColor: Color(0xFF121212),
      ),
      home: LoginScreen(), //
    );
  }
}