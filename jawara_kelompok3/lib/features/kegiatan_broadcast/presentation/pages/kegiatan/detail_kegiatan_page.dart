import 'package:flutter/material.dart';

class DetailKegiatanPage extends StatelessWidget {
  final Map<String, String> kegiatan;

  const DetailKegiatanPage({super.key, required this.kegiatan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(kegiatan["nama"] ?? "Detail Kegiatan")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Jenis: ${kegiatan["jenis"]}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Tanggal: ${kegiatan["tanggal"]}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Lokasi: ${kegiatan["lokasi"]}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            const Text("Dokumentasi:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: const Text("Belum ada dokumentasi"),
            ),
          ],
        ),
      ),
    );
  }
}
