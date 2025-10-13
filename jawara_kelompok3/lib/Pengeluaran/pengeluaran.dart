import 'package:flutter/material.dart';
import '../main.dart';

class PengeluaranPage extends StatelessWidget {
  const PengeluaranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengeluaran")),
      drawer: const AppSidebar(),
      body: const Center(
        child: Text("Halaman Pengeluaran (isi nanti)"),
      ),
    );
  }
}
