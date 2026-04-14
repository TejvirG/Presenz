import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PresenzApp());
}

class PresenzApp extends StatelessWidget {
  const PresenzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Presenz',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
