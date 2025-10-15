import 'package:flutter/material.dart';
import '../main.dart';
import '../Layout/sidebar.dart';

class ManajemenPenggunaPage extends StatelessWidget {
  const ManajemenPenggunaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manajemen Pengguna")),
      drawer: const AppSidebar(),
      body: const Center(
        child: Text("Halaman Manajemen Pengguna (isi nanti)"),
      ),
    );
  }
}
