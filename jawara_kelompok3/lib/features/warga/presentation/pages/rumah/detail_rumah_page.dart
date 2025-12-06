import 'package:flutter/material.dart';
import '../../../data/models/rumah_model.dart';

// 🔹 import service keluarga
import '../../../data/services/keluarga_service.dart';
import '../../../data/models/keluarga_model.dart';

class DetailRumahDialog extends StatelessWidget {
  final RumahModel rumah;
  const DetailRumahDialog({super.key, required this.rumah});

  @override
  Widget build(BuildContext context) {
    final keluargaService = KeluargaService();

    return AlertDialog(
      title: const Text("Detail Rumah"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nomor Rumah (id): ${rumah.id}"),
          const SizedBox(height: 8),
          Text("Alamat: ${rumah.alamat}"),
          const SizedBox(height: 8),
          Text("RT/RW: ${rumah.rt}/${rumah.rw}"),
          const SizedBox(height: 8),

          // 🔹 Penghuni diambil dari koleksi keluarga (id_rumah == rumah.docId)
          FutureBuilder<KeluargaModel?>(
            future: keluargaService
                .getKeluargaByRumahId(rumah.docId), // ⬅️ method baru
            builder: (context, snapshot) {
              String text = "Penghuni (Keluarga): -";

              if (snapshot.connectionState == ConnectionState.waiting) {
                text = "Penghuni (Keluarga): (memuat...)";
              } else if (snapshot.hasError) {
                text = "Penghuni (Keluarga): -";
              } else if (snapshot.hasData && snapshot.data != null) {
                text = "Penghuni (Keluarga): ${snapshot.data!.kepalaKeluarga}";
              }

              return Text(text);
            },
          ),

          const SizedBox(height: 8),
          Text("Kepemilikan: ${rumah.kepemilikan}"),
          const SizedBox(height: 8),
          Text("Status Rumah: ${rumah.statusRumah}"),
          const SizedBox(height: 12),
          Text(
            "Dibuat: ${rumah.createdAt != null ? rumah.createdAt.toString().substring(0, 16) : '-'}",
          ),
          if (rumah.updatedAt != null) ...[
            const SizedBox(height: 6),
            Text(
              "Diubah: ${rumah.updatedAt.toString().substring(0, 16)}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
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
}
