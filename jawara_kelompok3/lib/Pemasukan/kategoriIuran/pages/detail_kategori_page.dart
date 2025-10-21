import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class DetailKategoriDialog extends StatelessWidget {
  final Map<String, String> kategori;

  const DetailKategoriDialog({super.key, required this.kategori});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Detail Kategori Iuran",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text(
              "Informasi lengkap kategori iuran.",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),

            _buildField("Nama Iuran", kategori["nama"] ?? "-"),
            const SizedBox(height: 16),

            _buildField("Jenis Iuran", kategori["jenis"] ?? "-"),
            const SizedBox(height: 16),

            _buildField("Nominal (Rp)", kategori["nominal"] ?? "-"),

            const SizedBox(height: 24),
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
        border: const OutlineInputBorder(),
      ),
    );
  }
}
