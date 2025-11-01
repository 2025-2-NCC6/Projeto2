import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';

class EstoqueScreen extends StatelessWidget {
  const EstoqueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final produtos = [
      {"nome": "Trufa 1", "quantidade": 9},
      {"nome": "Trufa 2", "quantidade": 3},
      {"nome": "Trufa 3", "quantidade": 1},
      {"nome": "Trufa 4", "quantidade": 7},
    ];

    return Scaffold(
      appBar: const CustomAppBar(title: "Estoque"),
      body: ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, i) {
          final p = produtos[i];
          return ListTile(
            title: Text(p["nome"].toString()),
            trailing: Text("${p["quantidade"]} un."),
          );
        },
      ),
    );
  }
}
