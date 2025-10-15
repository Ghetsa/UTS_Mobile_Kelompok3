import 'package:flutter/material.dart';
import '../../../main.dart';

class DetailKategoriPage extends StatelessWidget {
  const DetailKategoriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Kategori Iuran"),
        backgroundColor: const Color(0xFF2D531A),
        foregroundColor: const Color(0xFFEBDDD0),
      ),
      drawer: const AppSidebar(),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Halaman detail / filter kategori iuran"),
          ],
        ),
      ),
    );
  }
}
