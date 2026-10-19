
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MeusPedidosCliente extends StatelessWidget {
  const MeusPedidosCliente({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      return const Scaffold(
        body: Center(
          child: Text('Faça login para continuar'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 167, 125, 123),
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        backgroundColor: const Color.fromARGB(255, 172, 134, 149),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('pedidos')
            .where('uid', isEqualTo: usuario.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar os pedidos'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final pedidos = snapshot.data?.docs ?? [];

          if (pedidos.isEmpty) {
            return const Center(
              child: Text('Nenhum pedido encontrado'),
            );
          }

          return ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final pedido = pedidos[index].data();

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    pedido['produto']?.toString() ?? 'Produto',
                  ),
                  subtitle: Text(
                    'Quantidade: ${pedido['quantidade'] ?? 0}\n'
                    'Local: ${pedido['local'] ?? 'Não informado'}\n'
                    'Status: ${pedido['compra'] ?? 'Pendente'}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}