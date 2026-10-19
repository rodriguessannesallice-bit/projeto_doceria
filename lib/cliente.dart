
import 'package:flutter/material.dart';
import 'explorar_produtos.dart';
import 'meus_pedidos_cliente.dart';
import 'perfil_cliente.dart';

class TelaCliente extends StatelessWidget {
  const TelaCliente({super.key});

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
                "Área do cliente",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 118, 54, 67),
                ),
              ),
              const Text(
                "Como deseja continuar?",
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
                      builder: (context) => const ExplorarProdutos(),
                    ),
                  );
                },
                child: const Text(
                  "Explorar produtos e serviços",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 112, 86, 81),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MeusPedidosCliente(),
                    ),
                  );
                },
                child: const Text(
                  "Meus pedidos",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 102, 77, 77),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PerfilCliente(),
                    ),
                  );
                },
                child: const Text(
                  "Meu perfil",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 102, 77, 77),
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