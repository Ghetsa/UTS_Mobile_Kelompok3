import 'package:flutter/material.dart';
import '../../data/models/kegiatan_model.dart';
import '../../data/services/kegiatan_service.dart';
import '../../presentation/widgets/kegiatan_card.dart';
import '../../presentation/widgets/kegiatan_filter.dart';

class DetailKegiatanDialog extends StatelessWidget {
  final KegiatanModel data;

  const DetailKegiatanDialog({super.key, required this.data});

  String _formatDate(DateTime? d) {
    if (d == null) return '-';
    return "${d.day.toString().padLeft(2, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.year}";
  }

  Widget _row(String l, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text("$l: $v"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Detail ${data.nama}"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row("Kategori", data.kategori),
            _row("Lokasi", data.lokasi),
            _row("Penanggung Jawab", data.penanggungJawab),
            _row("Status", data.status),
            _row("Tanggal Mulai", _formatDate(data.tanggalMulai)),
            _row("Tanggal Selesai", _formatDate(data.tanggalSelesai)),
            const SizedBox(height: 8),
            const Text(
              "Keterangan:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(data.keterangan.isEmpty ? "-" : data.keterangan),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Tutup"),
        ),
      ],
    );
  }
}
