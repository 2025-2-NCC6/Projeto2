import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Dashboard"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "25°C",
              style: TextStyle(fontSize: 64, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              "Vendas Mensal: R\$ 30.000",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              "Consumo de Energia: 150 kWh",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildCard(context, "Luzes", Icons.lightbulb, '/luzes'),
                _buildCard(context, "Ar-condicionado", Icons.ac_unit, '/ar'),
                _buildCard(context, "Estoque", Icons.store, '/estoque'),
                _buildCard(context, "Alertas", Icons.notifications, '/alertas'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext ctx,
    String title,
    IconData icon,
    String route,
  ) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(ctx, route),
      child: Container(
        width: 150,
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFFFC61A), size: 40),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
