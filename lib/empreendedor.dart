
import 'package:flutter/material.dart';

import 'meus_produtos.dart';
import 'meus_pedidos.dart';
import 'meu_perfil.dart';

class TelaEmpreendedor extends StatelessWidget {
  const TelaEmpreendedor({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 167, 125, 123),
      body: Center(
        child: Container(
          width: 300,
          height: 400,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 172, 134, 149),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Meu negócio',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 118, 54, 67),
                ),
              ),

              const Text(
                'O que deseja fazer?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 77, 24, 42),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MeusProdutos(),
                    ),
                  );
                },
                child: const Text('Meus produtos e serviços'),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MeusPedidos(),
                    ),
                  );
                },
                child: const Text('Pedidos'),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MeuPerfil(),
                    ),
                  );
                },
                child: const Text('Meu perfil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}