import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';

class AlertasScreen extends StatelessWidget {
  const AlertasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alertas = [
      "Estoque baixo: Trufa 3",
      "Temperatura acima do normal (27°C)",
      "Luz principal acesa há mais de 3h",
    ];

    return Scaffold(
      appBar: const CustomAppBar(title: "Alertas"),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: alertas.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder:
            (_, i) => ListTile(
              leading: const Icon(Icons.warning, color: Color(0xFFFFC61A)),
              title: Text(alertas[i]),
            ),
      ),
    );
  }
}
