import 'package:flutter/material.dart';
import '../../../data/models/warga_model.dart';

class DetailWargaPage extends StatelessWidget {
  final WargaModel data;
  const DetailWargaPage({super.key, required this.data});

  String _formatDate(DateTime? dt) {
    if (dt == null) return "-";
    return "${dt.day.toString().padLeft(2, '0')}-"
        "${dt.month.toString().padLeft(2, '0')}-"
        "${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Detail ${data.nama}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row("NIK", data.nik),
          _row("No KK", data.noKk),
          _row("No HP", data.noHp),
          _row("Agama", data.agama),
          _row("Jenis Kelamin", data.jenisKelamin),
          _row("Pekerjaan", data.pekerjaan),
          _row("Pendidikan", data.pendidikan.toUpperCase()),
          _row("Status Warga", data.statusWarga),
          _row("ID Rumah", data.idRumah),
          _row("Tanggal Lahir", _formatDate(data.tanggalLahir)),
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
