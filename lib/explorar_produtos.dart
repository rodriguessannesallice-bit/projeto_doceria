
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExplorarProdutos extends StatelessWidget {
  const ExplorarProdutos({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 167, 125, 123),
      appBar: AppBar(
        title: const Text('Explorar Produtos'),
        backgroundColor: const Color.fromARGB(255, 172, 134, 149),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: firestore.collection('produtos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar produtos'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final produtos = snapshot.data!.docs;

          if (produtos.isEmpty) {
            return const Center(
              child: Text('Nenhum produto disponível'),
            );
          }

          return ListView.builder(
            itemCount: produtos.length,
            itemBuilder: (context, index) {
              final produto = produtos[index].data();

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: Image.network(
                    produto['imagem'] ?? '',
                    width: 60,
                    height: 60,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.cake);
                    },
                  ),
                  title: Text(produto['nome'] ?? 'Produto'),
                  subtitle: Text('R\$ ${produto['preco'] ?? '0'}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      final usuario = FirebaseAuth.instance.currentUser;

                      if (usuario == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Faça login para fazer um pedido'),
                          ),
                        );
                        return;
                      }

                      final clienteController = TextEditingController();
                      final quantidadeController = TextEditingController();

                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Fazer pedido'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: clienteController,
                                  decoration: const InputDecoration(
                                    labelText: 'Nome do cliente',
                                  ),
                                ),
                                TextField(
                                  controller: quantidadeController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Quantidade',
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final quantidade = int.tryParse(
                                    quantidadeController.text,
                                  );

                                  if (clienteController.text.trim().isEmpty ||
                                      quantidade == null ||
                                      quantidade <= 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Preencha os campos corretamente',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  try {
                                    await firestore.collection('pedidos').add({
                                      'cliente': clienteController.text.trim(),
                                      'produto': produto['nome'] ?? 'Produto',
                                      'quantidade': quantidade,
                                      'compra': 'Pendente',
                                      'local': 'A definir',
                                      'uid': usuario.uid,
                                      'empreendedorUid': produto['uid'],
                                    });

                                    if (!context.mounted) return;

                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Pedido realizado com sucesso!'),
                                      ),
                                    );
                                  } catch (e) {
                                    if (!context.mounted) return;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Erro ao realizar pedido: $e'),
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Confirmar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Pedir'),
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