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
          _row("Jenis Mutasi", data.jenisMutasi),
          _row("ID Warga", data.idWarga),
          _row("Keterangan", data.keterangan),
          _row(
            "Tanggal Mutasi",
            data.tanggal != null ? data.tanggal.toString() : "-",
          ),
          _row(
            "Dibuat Pada",
            data.createdAt != null ? data.createdAt.toString() : "-",
          ),
          _row(
            "Terakhir Diupdate",
            data.updatedAt != null ? data.updatedAt.toString() : "-",
          ),
          _row("UID Dokumen", data.uid),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Tutup"),
        ),
      ],
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        "$label: $value",
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
