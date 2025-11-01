import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';

class ArCondicionadoScreen extends StatefulWidget {
  const ArCondicionadoScreen({super.key});

  @override
  State<ArCondicionadoScreen> createState() => _ArCondicionadoScreenState();
}

class _ArCondicionadoScreenState extends State<ArCondicionadoScreen> {
  double temperatura = 22;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Ar-condicionado"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${temperatura.toInt()}°C",
              style: const TextStyle(fontSize: 60),
            ),
            Slider(
              value: temperatura,
              min: 16,
              max: 30,
              activeColor: const Color(0xFFFFC61A),
              onChanged: (v) => setState(() => temperatura = v),
            ),
          ],
        ),
      ),
    );
  }
}
