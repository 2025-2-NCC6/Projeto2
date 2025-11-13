import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'loja_screen.dart';
import 'estoque_screen.dart';


class AlertasScreen extends StatefulWidget {
  const AlertasScreen({super.key});

  @override
  State<AlertasScreen> createState() => _AlertasScreenState();
}

class _AlertasScreenState extends State<AlertasScreen> {
  bool _isLoading = true;
  List<String> _alertas = [];

  static const Color background = Color(0xFF111111);
  static const Color accentColor = Color(0xFFFFC61A);
  static const Color cardColor = Color(0xFF1E1E1E);

  @override
  void initState() {
    super.initState();
    _fetchAlertData();
  }

  bool _parseStatus(dynamic value) {
    if (value is String) {
      final v = value.toLowerCase();
      if (v == 'activate') return true;
      if (v == 'deactivate') return false;
    }
    return false;
  }

  Future<void> _fetchAlertData() async {
    try {
      final response = await http.get(
        Uri.parse('https://khprnw-3001.csb.app/statusAlertas'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<String> generatedAlerts = [];


        final double temperatura = (data['temperatura'] as num?)?.toDouble() ?? 25.0;
        if (temperatura > 21.0) {
          generatedAlerts.add("Temperatura acima do recomendado (${temperatura.toStringAsFixed(1)}°C)");
        }else if (temperatura < 18.0) {
          generatedAlerts.add("Temperatura abaixo do recomendado (${temperatura.toStringAsFixed(1)}°C)");
        }

        final String cor = (data['cor']);
        if(cor == "amarelo"){
          generatedAlerts.add("Prateleiras de trufas de chocolate precisam de reposição");
        }

        final double luminosidadeLoja = (data['luminosidadeloja'] as num?)?.toDouble() ?? 25.0;
        if (luminosidadeLoja > 60) {
          generatedAlerts.add("A luminosidade da loja está baixa, recomendado ligar as luzes");
        }else{
          generatedAlerts.add("A luminosidade da loja está alta, recomendado apagar as luzes");
        }

        setState(() {
          _alertas = generatedAlerts;
          _isLoading = false;
        });

      } else {
        print('Erro na requisição: ${response.statusCode}');
        setState(() {
          _alertas = ["Erro ao carregar dados."];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erro ao buscar status da loja: $e');
      setState(() {
        _alertas = ["Erro de conexão."];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              height: 40,
            ),
            const SizedBox(width: 40),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LojaScreen()));
              },
              child: const Text("LOJA",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            const SizedBox(width: 30),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const EstoqueScreen()));
              },
              child: const Text("ESTOQUE",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            const SizedBox(width: 30),
            InkWell(
              onTap: () {
                if (!_isLoading) {
                  setState(() => _isLoading = true);
                  _fetchAlertData();
                }
              },
              child: const Text("ALERTAS",
                  style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: accentColor))
          : _buildAlertList(),
    );
  }

  Widget _buildAlertList() {
    if (_alertas.isEmpty) {
      return const Center(
        child: Text(
          "Nenhum alerta no momento.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _alertas.length,
      separatorBuilder: (_, __) => const Divider(color: cardColor),
      itemBuilder: (_, i) => ListTile(
        leading: const Icon(Icons.warning, color: accentColor),
        title: Text(
          _alertas[i],
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}