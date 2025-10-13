import 'package:flutter/material.dart';
import 'pages/iuran_page.dart';
import 'pages/tambah_iuran_page.dart';
import 'pages/detail_page.dart';

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
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const IuranPage(),
        '/tambah': (context) => const TambahIuranPage(),
        '/detail': (context) => const DetailPage(),
      },
    );
  }
}
