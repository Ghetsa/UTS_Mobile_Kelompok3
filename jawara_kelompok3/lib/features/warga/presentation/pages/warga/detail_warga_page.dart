import 'package:flutter/material.dart';

class DetailWargaPage extends StatelessWidget {
  final Map<String, dynamic> warga;
  const DetailWargaPage({super.key, required this.warga});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Detail ${warga['nama']}"),
      content: Text("Detail lengkap warga."),
    );
  }
}
