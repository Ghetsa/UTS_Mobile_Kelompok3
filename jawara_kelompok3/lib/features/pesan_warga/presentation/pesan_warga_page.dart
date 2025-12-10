import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../../core/layout/sidebar.dart';

class PesanWargaPage extends StatelessWidget {
  const PesanWargaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pesan Warga")),
      drawer: const AppSidebar(),
      body: const Center(
        child: Text("Halaman Pesan Warga (isi nanti)"),
      ),
    );
  }
}
