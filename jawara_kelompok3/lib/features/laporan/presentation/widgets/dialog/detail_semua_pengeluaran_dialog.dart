import 'package:flutter/material.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../data/models/semua_pengeluaran_model.dart';

class DetailPengeluaranDialog extends StatelessWidget {
  final PengeluaranModel pengeluaran;

  const DetailPengeluaranDialog({super.key, required this.pengeluaran});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Detail Pengeluaran", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildField("Nama", pengeluaran.nama),
            const SizedBox(height: 12),
            _buildField("Jenis", pengeluaran.jenis),
            const SizedBox(height: 12),
            _buildField("Tanggal", pengeluaran.tanggal),
            const SizedBox(height: 12),
            _buildField("Nominal", pengeluaran.nominal),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                child: const Text("Tutup"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return TextFormField(
      readOnly: true,
      initialValue: value,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
    );
  }
}
