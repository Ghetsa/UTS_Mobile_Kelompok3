import 'package:flutter/material.dart';
import 'package:jawara_kelompok3/main.dart';

class DaftarMutasiPage extends StatelessWidget {
  const DaftarMutasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mutasi Keluarga")),
      drawer: const AppSidebar(),
      body: const Center(child: Text("Halaman Mutasi Keluarga (isi nanti)")),
    );
  }
}
