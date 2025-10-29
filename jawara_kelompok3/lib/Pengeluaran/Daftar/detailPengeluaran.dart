import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class DetailPengeluaranDialog extends StatelessWidget {
  final Map<String, String> pengeluaran;

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
            const Text(
              "Detail Pengeluaran",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildField("Nama", pengeluaran["nama"] ?? "-"),
            const SizedBox(height: 12),

            _buildField("Jenis Pengeluaran", pengeluaran["jenis"] ?? "-"),
            const SizedBox(height: 12),

            _buildField("Tanggal", pengeluaran["tanggal"] ?? "-"),
            const SizedBox(height: 12),

            _buildField("Nominal", pengeluaran["nominal"] ?? "-"),
            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Tutup",
                  style: TextStyle(color: Colors.white),
                ),
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
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontWeight: FontWeight.w500),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}
