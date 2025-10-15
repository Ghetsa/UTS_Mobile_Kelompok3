import 'package:flutter/material.dart';
import '../main.dart';

class LaporanKeuanganPage extends StatelessWidget {
  const LaporanKeuanganPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Laporan Keuangan")),
      drawer: const AppSidebar(),
      body: const Center(
        child: Text("Halaman Laporan Keuangan (isi nanti)"),
      ),
    );
  }
}
