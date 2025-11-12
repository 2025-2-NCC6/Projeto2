import 'package:flutter/material.dart';

class LuzesArScreen extends StatefulWidget {
  const LuzesArScreen({super.key});

  @override
  State<LuzesArScreen> createState() => _LuzesArScreenState();
}

class _LuzesArScreenState extends State<LuzesArScreen> {
  bool luzPrincipal = true;
  bool luzEstoque = true;
  bool arPrincipal = true;
  double temperatura = 22.0;

  @override
  Widget build(BuildContext context) {
    const Color background = Color(0xFF111111);
    const Color cardColor = Color(0xFF1E1E1E);
    const Color accentColor = Color(0xFFFFC61A);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 60,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 40,
            ),
            const SizedBox(width: 40),
            const Text(
              "HOME",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(width: 30),
            const Text(
              "ESTOQUE",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(width: 30),
            const Text(
              "LUZES/AR",
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PAINEL DE LUZES
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Luzes",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // CARDS DE LUZES
                    Row(
                      children: [
                        _luzCard(
                          "Principal",
                          luzPrincipal,
                              (v) => setState(() => luzPrincipal = v),
                        ),
                        const SizedBox(width: 20),
                        _luzCard(
                          "Estoque",
                          luzEstoque,
                              (v) => setState(() => luzEstoque = v),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),

            // PAINEL DE AR CONDICIONADO
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ar-condicionado",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // CARD DE AR PRINCIPAL
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Principal",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Ligado",
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${temperatura.toStringAsFixed(0)}°",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // BOTÃO DE TUDO LIGADO
                    Container(
                      width: 160,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: const [
                          Icon(Icons.power_settings_new, color: Colors.black),
                          SizedBox(height: 6),
                          Text(
                            "Tudo ligado",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === WIDGET CARD DE LUZ ===
  Widget _luzCard(String titulo, bool value, Function(bool) onChanged) {
    const Color accentColor = Color(0xFFFFC61A);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.light_mode, color: Colors.black, size: 30),
                Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: Colors.black,
                  inactiveTrackColor: Colors.black38,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              titulo,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Ligado",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
