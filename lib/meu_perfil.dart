
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MeuPerfil extends StatefulWidget {
  const MeuPerfil({super.key});

  @override
  State<MeuPerfil> createState() => _MeuPerfilState();
}

class _MeuPerfilState extends State<MeuPerfil> {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  final nomeController = TextEditingController();
  final negocioController = TextEditingController();
  final localController = TextEditingController();

  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarPerfil();
  }

  void carregarPerfil() async {
    final usuario = auth.currentUser;

    if (usuario != null) {
      final documento = await firestore
          .collection('perfis')
          .doc(usuario.uid)
          .get();

      if (documento.exists) {
        final dados = documento.data()!;

        nomeController.text = dados['nome'] ?? '';
        negocioController.text = dados['negocio'] ?? '';
        localController.text = dados['localRetirada'] ?? '';
      }
    }

    if (mounted) {
      setState(() {
        carregando = false;
      });
    }
  }

  void salvarPerfil() async {
    final usuario = auth.currentUser;

    if (usuario == null) return;

    await firestore.collection('perfis').doc(usuario.uid).set({
      'nome': nomeController.text,
      'negocio': negocioController.text,
      'localRetirada': localController.text,
      'email': usuario.email ?? '',
      'uid': usuario.uid,
    }, SetOptions(merge: true));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perfil salvo com sucesso!'),
      ),
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    negocioController.dispose();
    localController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usuario = auth.currentUser;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 167, 125, 123),
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: const Color.fromARGB(255, 172, 134, 149),
        foregroundColor: Colors.white,
      ),
      body: carregando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : usuario == null
              ? const Center(
                  child: Text('Faça login para continuar'),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 90,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),

                      TextField(
                        controller: nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome do empreendedor',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),

                      TextField(
                        controller: negocioController,
                        decoration: const InputDecoration(
                          labelText: 'Nome do negócio',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),

                      TextField(
                        controller: localController,
                        decoration: const InputDecoration(
                          labelText: 'Local de retirada',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),

                      TextField(
                        readOnly: true,
                        controller: TextEditingController(
                          text: usuario.email ?? '',
                        ),
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: salvarPerfil,
                        child: const Text('Salvar Perfil'),
                      ),
                    ],
                  ),
                ),
    );
  }
}