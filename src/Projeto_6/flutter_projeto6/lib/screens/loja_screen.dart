import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'loja_screen.dart';
import 'alertas_screen.dart';
import 'estoque_screen.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ControLAP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFFC61A),
        scaffoldBackgroundColor: const Color(0xFF1C1C1C),
        fontFamily: 'Roboto',
      ),
      home: const LojaScreen(),
    );
  }
}

class LojaScreen extends StatefulWidget {
  const LojaScreen({super.key});

  @override
  State<LojaScreen> createState() => _LojaScreenState();
}

class _LojaScreenState extends State<LojaScreen> {
  bool isLoading = true;
  bool automacoes = true;
  bool luzesLoja = true;
  bool arCondicionado = true;
  double temperatura = 25.0;
  int unidades_trufas = 0;


  @override
  void initState() {
    super.initState();
    getStatusLoja();
  }

  bool parseStatus(dynamic value) {
    if (value is String) {
      final v = value.toLowerCase();
      if (v == 'activate') return true;
      if (v == 'deactivate') return false;
    }
    return false;
  }


  Future<void> getStatusLoja() async {
    try {
      final response = await http.get(
        Uri.parse('https://khprnw-3001.csb.app/statusLoja'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          automacoes = parseStatus(data['automacoes']);
          luzesLoja = parseStatus(data['ledloja']);
          arCondicionado = parseStatus(data['arcondicionadoloja']);

          temperatura = (data['temperaturaloja'] as num?)?.toDouble() ?? 25.0;

          unidades_trufas = data['unidades_trufas'];

          isLoading = false;
        });
      } else {
        print('Erro na requisição: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Erro ao buscar status da loja: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> alterarArLoja(bool status) async {
    try {
      final url = status
          ? 'https://khprnw-3001.csb.app/ligarArCondicionadoLoja'
          : 'https://khprnw-3001.csb.app/desligarArCondicionadoLoja';

      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Luz loja atualizada com sucesso!');
        await Future.delayed(const Duration(seconds: 1));
        await getStatusLoja();
      } else {
        print('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao alterar status da luz do loja: $e');
    }
  }

  Future<void> alterarLuzLoja(bool status) async {
    try {
      final url = status
          ? 'https://khprnw-3001.csb.app/ligarLuzLoja'
          : 'https://khprnw-3001.csb.app/desligarLuzLoja';

      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Luz Loja atualizada com sucesso!');
        await Future.delayed(const Duration(seconds: 1));
        await getStatusLoja();
      } else {
        print('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao alterar status da luz do Loja: $e');
    }
  }

  Future<void> alterarEstadoAutomacoes(bool status) async {
    try {
      final url = status
          ? 'https://khprnw-3001.csb.app/ativarAutomacoes'
          : 'https://khprnw-3001.csb.app/desativarAutomacoes';

      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Automações atualizadas com sucesso!');
        await Future.delayed(const Duration(seconds: 1));
        await getStatusLoja();
      } else {
        print('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao alterar status das automações: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    const Color background = Color(0xFF111111);
    const Color cardColor = Color(0xFF1E1E1E);
    const Color accentColor = Color(0xFFFFC61A);

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LojaScreen()));
            },
            child: const Text("LOJA",
                style: TextStyle(color: Color(0xFFFFC61A), fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
          const SizedBox(width: 30),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => EstoqueScreen()));
            },
            child: const Text("ESTOQUE",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          const SizedBox(width: 30),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AlertasScreen()));
            },
            child: const Text("ALERTAS",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Color(0xFFFFC61A),
        ),
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _buildLeftColumn(),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 3,
              child: _buildRightColumn(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      children: [
        _buildThermostatCard(),
        const SizedBox(height: 20),
        _buildShelvesCard(),
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      children: [
        _buildControllersCard(),
      ],
    );
  }

  Widget _buildThermostatCard() {
    double minTemp = 5.0;
    double maxTemp = 50.0;
    double progress = (temperatura - minTemp) / (maxTemp - minTemp);

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF111111),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CircularProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                strokeWidth: 12,
                backgroundColor: Colors.white.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC61A)),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                "${temperatura.toStringAsFixed(1)}°C",
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShelvesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Prateleiras',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trufa de Chocolate',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              Text(
                'Unidades: $unidades_trufas',
                style: const TextStyle(fontSize: 18, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControllersCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Controladores',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildControllerRow(
            'Automações',
            automacoes,
                (newValue) {
              setState(() => automacoes = newValue);
              alterarEstadoAutomacoes(newValue);
            },
          ),
          _buildControllerRow(
            'Luz',
            luzesLoja,
                (newValue) {
              setState(() => luzesLoja = newValue);
              alterarLuzLoja(newValue);
            },
          ),
          _buildControllerRow(
            'Ar-condicionado',
            arCondicionado,
                (newValue) {
              setState(() => arCondicionado = newValue);
              alterarArLoja(newValue);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControllerRow(
      String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Color(0xFFFFC61A),
            activeTrackColor: Color(0xFFFFC61A).withOpacity(0.5),
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withOpacity(0.4),
          ),
        ],
      ),
    );
  }
}