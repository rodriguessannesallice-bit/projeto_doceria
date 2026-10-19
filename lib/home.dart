import 'authentication.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          "Usuário logado com sucesso.",
          style: TextStyle(fontSize: 16),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AuthenticationHelper().signOut().then(
            (_) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            ),
          );
        },
        tooltip: 'Logout',
        child: const Icon(Icons.logout),
      ),
    );
  }
}
