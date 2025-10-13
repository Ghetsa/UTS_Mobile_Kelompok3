import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Iuran")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("No: ${data['no']}"),
            Text("Nama: ${data['nama']}"),
            Text("Jenis: ${data['jenis']}"),
            Text("Nominal: ${data['nominal']}"),
          ],
        ),
      ),
    );
  }
}
