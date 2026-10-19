
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PerfilCliente extends StatefulWidget {
  const PerfilCliente({super.key});

  @override
  State<PerfilCliente> createState() => _PerfilClienteState();
}

class _PerfilClienteState extends State<PerfilCliente> {
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();

  final usuario = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    carregarPerfil();
  }

  void carregarPerfil() async {
    if (usuario == null) return;

    final documento = await FirebaseFirestore.instance
        .collection('perfis')
        .doc(usuario!.uid)
        .get();

    if (documento.exists) {
      final dados = documento.data()!;

      nomeController.text = dados['nome'] ?? '';
      telefoneController.text = dados['telefone'] ?? '';
    }
  }

  void salvarPerfil() async {
    if (usuario == null) return;

    await FirebaseFirestore.instance
        .collection('perfis')
        .doc(usuario!.uid)
        .set({
      'nome': nomeController.text,
      'email': usuario!.email ?? '',
      'telefone': telefoneController.text,
      'tipo': 'cliente',
    }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Perfil salvo com sucesso!'),
      ),
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 167, 125, 123),
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: const Color.fromARGB(255, 172, 134, 149),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 172, 134, 149),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 35,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),

                Text(
                  'E-mail: ${usuario?.email ?? 'Não informado'}',
                ),
                const SizedBox(height: 15),

                TextField(
                  controller: telefoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
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
        ),
      ),
    );
  }
}