import 'package:flutter/material.dart';
import '../../../data/models/mutasi_model.dart';

class DetailMutasiDialog extends StatelessWidget {
  final MutasiModel data;

  const DetailMutasiDialog({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Detail Mutasi"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row("Jenis", data.jenis),
          _row("ID Warga", data.idWarga),
          _row("Alasan", data.alasan),
          _row("Tanggal", data.tanggal?.toString() ?? "-"),
          _row("Dibuat Oleh", data.dibuatOleh),
          _row("UID", data.uid),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tutup")),
      ],
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text("$label: $value", style: const TextStyle(fontSize: 14)),
    );
  }
}
