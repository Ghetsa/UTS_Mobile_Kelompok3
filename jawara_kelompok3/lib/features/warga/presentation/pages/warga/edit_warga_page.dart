import 'package:flutter/material.dart';

class EditWargaPage extends StatelessWidget {
  final Map<String, dynamic> warga;
  const EditWargaPage({super.key, required this.warga});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit ${warga['nama']}"),
      content: const Text("Form edit warga."),
    );
  }
}
