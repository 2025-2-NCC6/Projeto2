import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EstoqueScreen extends StatefulWidget {
  const EstoqueScreen({super.key});

  @override
  State<EstoqueScreen> createState() => _EstoqueScreenState();
}

class _EstoqueScreenState extends State<EstoqueScreen> {
  bool luzEstoque = true;
  double temperatura = 25.0;
  bool arLigado = true;
  bool isLoading = true;
  int unidades_trufas = 0;
  int caixas_trufas = 0;

  @override
  void initState() {
    super.initState();
    getStatusLuzes();
  }

  bool parseStatus(dynamic value) {
    if (value is String) {
      final v = value.toLowerCase();
      if (v == 'activate') return true;
      if (v == 'deactivate') return false;
    }
    return false;
  }

  Future<void> getStatusLuzes() async {
    try {
      final response = await http.get(
        Uri.parse('https://khprnw-3001.csb.app/statusEstoque'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          luzEstoque = parseStatus(data['ledestoque']);
          arLigado = parseStatus(data['arcondicionadoloja']);
          temperatura = data['temperatura'] ?? "25°C";
          unidades_trufas = data['unidades_trufas'];
          caixas_trufas = data['caixas_trufas'];
          isLoading = false;
        });
      } else {
        print('Erro na requisição: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Erro ao buscar status das luzes do estoque: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> alterarLuzEstoque(bool status) async {
    try {
      final url = status
          ? 'https://khprnw-3001.csb.app/ligarLuzEstoque'
          : 'https://khprnw-3001.csb.app/desligarLuzEstoque';

      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Luz Estoque atualizada com sucesso!');
        await Future.delayed(const Duration(seconds: 1));
        await getStatusLuzes();
      } else {
        print('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao alterar status da luz do estoque: $e');
    }
  }

  Future<void> alterarArEstoque(bool status) async {
    try {
      final url = status
          ? 'https://khprnw-3001.csb.app/ligarArCondicionadoLoja'
          : 'https://khprnw-3001.csb.app/desligarArCondicionadoLoja';

      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Luz Estoque atualizada com sucesso!');
        await Future.delayed(const Duration(seconds: 1));
        await getStatusLuzes();
      } else {
        print('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao alterar status da luz do estoque: $e');
    }
  }

  late final List<Map<String, String>> produtos = [
    {"nome": "Trufa de chocolate ao leite", "Caixas": caixas_trufas.toString(), "Unidades": unidades_trufas.toString()},
  ];

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
            const Text("HOME",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(width: 30),
            const Text("ESTOQUE",
                style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            const SizedBox(width: 30),
            const Text("LUZES/AR",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: accentColor,
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Painel de produtos ===
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
                      "Produtos",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Expanded(
                      child: ListView.separated(
                        itemCount: produtos.length,
                        separatorBuilder: (_, __) =>
                        const Divider(color: Colors.grey),
                        itemBuilder: (context, index) {
                          final item = produtos[index];
                          return Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["nome"]!,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    "Unidades: ${item["Unidades"]}",
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                              Text(
                                "Caixas: ${item["Caixas"]}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "...",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 24),

            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${temperatura.toStringAsFixed(1)}°C",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _switchTile("Luzes", luzEstoque, (v) {
                      setState(() => luzEstoque = v);
                      alterarLuzEstoque(v);
                    }),
                    const Divider(color: Colors.grey),
                    _switchTile("Ar condicionado", arLigado, (v) {
                      setState(() => arLigado = v);
                      alterarArEstoque(v);
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchTile(String title, bool value, Function(bool) onChanged) {
    const Color accentColor = Color(0xFFFFC61A);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: accentColor,
          inactiveTrackColor: Colors.grey[700],
        ),
      ],
    );
  }
}
