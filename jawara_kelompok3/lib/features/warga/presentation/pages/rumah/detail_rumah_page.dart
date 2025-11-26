import 'package:flutter/material.dart';
import '../../../data/models/rumah_model.dart';

class DetailRumahDialog extends StatelessWidget {
  final RumahModel rumah;
  const DetailRumahDialog({super.key, required this.rumah});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Detail Rumah"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Alamat: ${rumah.alamat}"),
          const SizedBox(height: 8),
          Text("Penghuni: ${rumah.penghuni}"),
          const SizedBox(height: 8),
          Text("Kepemilikan: ${rumah.kepemilikan}"),
          const SizedBox(height: 8),
          Text("Status: ${rumah.status}"),
          if (rumah.idRumah != null) ...[
            const SizedBox(height: 8),
            Text("ID Rumah: ${rumah.idRumah}"),
          ],
          const SizedBox(height: 12),
          Text("Dibuat: ${rumah.createdAt != null ? rumah.createdAt.toString().substring(0, 16) : '-'}"),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Tutup")),
      ],
    );
  }
}
