import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'Theme/app_theme.dart'; // ✅ import theme

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Iuran Warga',
      theme: AppTheme.lightTheme, // ✅ panggil tema dari AppTheme
      initialRoute: '/',
      routes: AppRoutes.routes,
    );
  }
}