import 'package:flutter/material.dart';
import '../../../data/models/keluarga_model.dart';
import 'kelola_anggota_keluarga_page.dart';

class DetailKeluargaPage extends StatelessWidget {
  final KeluargaModel data;

  const DetailKeluargaPage({super.key, required this.data});

  Widget _row(String l, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text("$l: $v"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Detail ${data.kepalaKeluarga}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row("Kepala Keluarga", data.kepalaKeluarga),
          _row("No KK", data.noKk),
          _row("Rumah (docId)", data.idRumah),
          _row("Jumlah Anggota", data.jumlahAnggota),
          _row("Status", data.statusKeluarga),
          _row("docId", data.uid),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Tutup"),
          onPressed: () => Navigator.pop(context, false),
        ),
        TextButton(
          child: const Text("Kelola Anggota"),
          onPressed: () async {
            final res = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => KelolaAnggotaKeluargaPage(keluarga: data),
              ),
            );
            if (!context.mounted) return;

            // kalau ada perubahan, tutup dialog sambil kirim sinyal refresh
            Navigator.pop(context, res == true);
          },
        ),
      ],
    );
  }
}
