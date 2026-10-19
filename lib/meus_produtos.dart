
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MeusProdutos extends StatefulWidget {
  const MeusProdutos({super.key});

  @override
  State<MeusProdutos> createState() => _MeusProdutosState();
}

class _MeusProdutosState extends State<MeusProdutos> {
  final firestore = FirebaseFirestore.instance;

  final nome = TextEditingController();
  final preco = TextEditingController();
  final imagem = TextEditingController();

  @override
  void dispose() {
    nome.dispose();
    preco.dispose();
    imagem.dispose();
    super.dispose();
  }

  void cadastrar() async {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) return;

    final valor = double.tryParse(
      preco.text.replaceAll(',', '.'),
    );

    if (nome.text.trim().isEmpty ||
        valor == null ||
        valor < 0 ||
        imagem.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha os campos corretamente.'),
        ),
      );
      return;
    }

    await firestore.collection('produtos').add({
      'nome': nome.text,
      'preco': valor,
      'imagem': imagem.text,
      'uid': usuario.uid,
    });

    nome.clear();
    preco.clear();
    imagem.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Produto cadastrado!'),
      ),
    );
  }

  void excluir(String id) async {
    await firestore.collection('produtos').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      return const Scaffold(
        body: Center(child: Text('Faça login para continuar.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 167, 125, 123),
      appBar: AppBar(
        title: const Text('Meus Produtos'),
        backgroundColor: const Color.fromARGB(255, 172, 134, 149),
      ),
      body: Center(
        child: Container(
          width: 320,
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 172, 134, 149),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView(
            children: [
              const Text(
                'Cadastrar produto',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 77, 24, 42),
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: nome,
                decoration: const InputDecoration(
                  labelText: 'Nome do produto',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: preco,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Preço',
                  prefixText: 'R\$ ',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: imagem,
                decoration: const InputDecoration(
                  labelText: 'Link da imagem',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: cadastrar,
                child: const Text('Cadastrar'),
              ),
              const SizedBox(height: 25),

              const Text(
                'Meus produtos',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 77, 24, 42),
                ),
              ),

              StreamBuilder(
                stream: firestore
                    .collection('produtos')
                    .where('uid', isEqualTo: usuario.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final produtos = snapshot.data!.docs;

                  if (produtos.isEmpty) {
                    return const Text(
                      'Nenhum produto cadastrado.',
                      textAlign: TextAlign.center,
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: produtos.length,
                    itemBuilder: (context, index) {
                      final produto = produtos[index];

                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.fastfood),
                          title: Text(produto['nome']),
                          subtitle: Text('R\$ ${produto['preco']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => excluir(produto.id),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}