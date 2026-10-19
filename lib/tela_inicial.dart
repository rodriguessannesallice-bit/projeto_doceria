
import 'package:flutter/material.dart';
import 'login.dart';
import 'login_cliente.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 92, 64, 61),
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 212, 161, 182),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Bem-vindo!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 118, 54, 67),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Como deseja acessar?',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 77, 24, 42),
                ),
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                },
                child: const Text('Empreendedor'),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginCliente(),
                    ),
                  );
                },
                child: const Text('Cliente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}