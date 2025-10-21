import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class DetailPemasukanDialog extends StatelessWidget {
  final Map<String, dynamic> pemasukan;

  const DetailPemasukanDialog({super.key, required this.pemasukan});

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
            Row(
              children: [
                const Icon(Icons.attach_money, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  "Detail Pemasukan",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildField("Nama", pemasukan["nama"] ?? "-"),
            const SizedBox(height: 12),

            _buildField("Jenis Pemasukan", pemasukan["jenis"] ?? "-"),
            const SizedBox(height: 12),

            _buildField("Tanggal", pemasukan["tanggal"] ?? "-"),
            const SizedBox(height: 12),

            _buildField("Nominal", pemasukan["nominal"] ?? "-"),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white),
                label: const Text("Tutup"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Widget Helper Field
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }
}
