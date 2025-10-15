import 'package:flutter/material.dart';
import '../main.dart';
import '../Layout/sidebar.dart';

class DataWargaPage extends StatelessWidget {
  const DataWargaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Data Warga & Rumah")),
      drawer: const AppSidebar(),
      body: const Center(
        child: Text("Halaman Data Warga & Rumah (isi nanti)"),
      ),
    );
  }
}
