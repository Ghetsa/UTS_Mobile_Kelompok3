import 'package:flutter/material.dart';
import '../main.dart';
import '../Layout/sidebar.dart';

class MutasiKeluargaPage extends StatelessWidget {
  const MutasiKeluargaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mutasi Keluarga")),
      drawer: const AppSidebar(),
      body: const Center(
        child: Text("Halaman Mutasi Keluarga (isi nanti)"),
      ),
    );
  }
}



