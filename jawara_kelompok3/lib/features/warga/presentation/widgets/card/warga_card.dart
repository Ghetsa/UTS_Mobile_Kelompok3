import 'package:flutter/material.dart';
import '../chip/warga_status_chip.dart';

class WargaCard extends StatelessWidget {
  const WargaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text("Nama Warga"),
        subtitle: const Text("NIK - Nama Keluarga"),
        trailing: const WargaStatusChip(status: "Aktif"),
      ),
    );
  }
}
