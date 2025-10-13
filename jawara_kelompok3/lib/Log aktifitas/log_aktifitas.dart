import 'package:flutter/material.dart';
import '../main.dart';

class LogAktifitasPage extends StatelessWidget {
  const LogAktifitasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Log Aktifitas")),
      drawer: const AppSidebar(),
      body: const Center(
        child: Text("Halaman Log Aktifitas (isi nanti)"),
      ),
    );
  }
}
