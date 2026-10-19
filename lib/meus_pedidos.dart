
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MeusPedidos extends StatelessWidget {
  const MeusPedidos({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = FirebaseAuth.instance.currentUser;
    final firestore = FirebaseFirestore.instance;

    if (usuario == null) {
      return const Scaffold(
        body: Center(
          child: Text('Faça login para ver os pedidos'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 167, 125, 123),
      appBar: AppBar(
        title: const Text('Pedidos'),
        backgroundColor: const Color.fromARGB(255, 172, 134, 149),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: firestore
            .collection('pedidos')
            .where('empreendedorUid', isEqualTo: usuario.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final pedidos = snapshot.data!.docs;

          if (pedidos.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum pedido recebido para este empreendedor',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final pedido = pedidos[index].data();
              final id = pedidos[index].id;
              final status = pedido['compra'] ?? 'Pendente';

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(pedido['produto'] ?? 'Produto'),
                  subtitle: Text(
                    'Cliente: ${pedido['cliente'] ?? 'Não informado'}\n'
                    'Quantidade: ${pedido['quantidade'] ?? 0}\n'
                    'Status: $status',
                  ),
                  isThreeLine: true,
                  trailing: status == 'Pendente'
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () async {
                                try {
                                  await firestore
                                      .collection('pedidos')
                                      .doc(id)
                                      .update({'compra': 'Aceito'});

                                  await firestore
                                      .collection('pedidos')
                                      .doc(id)
                                      .collection('historico')
                                      .add({
                                    'status': 'Aceito',
                                    'data': Timestamp.now(),
                                    'empreendedorUid': usuario.uid,
                                  });
                                } catch (e) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Erro ao aceitar pedido',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Aceitar'),
                            ),
                            TextButton(
                              onPressed: () async {
                                try {
                                  await firestore
                                      .collection('pedidos')
                                      .doc(id)
                                      .update({'compra': 'Recusado'});

                                  await firestore
                                      .collection('pedidos')
                                      .doc(id)
                                      .collection('historico')
                                      .add({
                                    'status': 'Recusado',
                                    'data': Timestamp.now(),
                                    'empreendedorUid': usuario.uid,
                                  });
                                } catch (e) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Erro ao recusar pedido',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Recusar'),
                            ),
                          ],
                        )
                      : Text(status),
                ),
              );
            },
          );
        },
      ),
    );
  }
}