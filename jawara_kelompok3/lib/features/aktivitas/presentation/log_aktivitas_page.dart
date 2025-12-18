import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../../core/layout/sidebar.dart';

class LogAktivitasPage extends StatelessWidget {
  const LogAktivitasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Log Aktivitas")),
      drawer: const AppSidebar(),
      body: const Center(
        child: Text("Halaman Log Aktivitas (isi nanti)"),
      ),
    );
  }
}
