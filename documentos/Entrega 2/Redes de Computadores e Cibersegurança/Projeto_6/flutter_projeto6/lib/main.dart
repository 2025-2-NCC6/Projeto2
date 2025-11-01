import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/estoque_screen.dart';
import 'screens/luzes_screen.dart';
import 'screens/ar_condicionado_screen.dart';
import 'screens/alertas_screen.dart';

void main() {
  runApp(const ControLapApp());
}

class ControLapApp extends StatelessWidget {
  const ControLapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ControLAP',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginScreen(),
        '/dashboard': (_) => const DashboardScreen(),
        '/estoque': (_) => const EstoqueScreen(),
        '/luzes': (_) => const LuzesScreen(),
        '/ar': (_) => const ArCondicionadoScreen(),
        '/alertas': (_) => const AlertasScreen(),
      },
    );
  }
}
