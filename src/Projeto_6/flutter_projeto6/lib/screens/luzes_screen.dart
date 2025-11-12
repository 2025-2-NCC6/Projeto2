import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LuzesScreen extends StatefulWidget {
  const LuzesScreen({super.key});

  @override
  State<LuzesScreen> createState() => _LuzesScreenState();
}

class _LuzesScreenState extends State<LuzesScreen> {
  bool? luzLoja;
  bool? luzEstoque;
  bool isLoading = true;

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
        Uri.parse('https://khprnw-3001.csb.app/statusLuzes'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          luzLoja = parseStatus(data['ledloja']);
          luzEstoque = parseStatus(data['ledestoque']);
          isLoading = false; // terminou o carregamento
        });
      } else {
        print('Erro na requisição: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Erro ao buscar status das luzes: $e');
      setState(() => isLoading = false);
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
        await getStatusLuzes();
      } else {
        print('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao alterar status da luz da loja: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Luzes"),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFFFC61A),
        ),
      )
          : ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _switchTile("Luzes Estoque", luzEstoque!, (v) {
            setState(() => luzEstoque = v);
            alterarLuzEstoque(v);
          }),
          _switchTile("Luzes Loja", luzLoja!, (v) {
            setState(() => luzLoja = v);
            alterarLuzLoja(v);
          }),
        ],
      ),
    );
  }

  Widget _switchTile(String nome, bool valor, Function(bool) onChanged) {
    return SwitchListTile(
      value: valor,
      onChanged: onChanged,
      title: Text(nome),
      activeColor: const Color(0xFFFFC61A),
    );
  }
}