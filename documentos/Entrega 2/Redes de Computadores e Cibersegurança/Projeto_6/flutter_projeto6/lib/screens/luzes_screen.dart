import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';

class LuzesScreen extends StatefulWidget {
  const LuzesScreen({super.key});

  @override
  State<LuzesScreen> createState() => _LuzesScreenState();
}

class _LuzesScreenState extends State<LuzesScreen> {
  bool luz1 = true;
  bool luz2 = false;
  bool luz3 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Luzes"),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _switchTile("Luz Estoque", luz1, (v) => setState(() => luz1 = v)),
          _switchTile("Luz Principal 1", luz2, (v) => setState(() => luz2 = v)),
          _switchTile("Luz Principal 2", luz3, (v) => setState(() => luz3 = v)),
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
