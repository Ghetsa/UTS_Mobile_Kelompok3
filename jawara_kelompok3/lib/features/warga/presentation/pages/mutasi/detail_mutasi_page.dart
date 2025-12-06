import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/mutasi_model.dart';

class DetailMutasiDialog extends StatelessWidget {
  final MutasiModel data;

  const DetailMutasiDialog({super.key, required this.data});

  String _fmt(DateTime? dt) {
    if (dt == null) return "-";
    return "${dt.day.toString().padLeft(2, '0')}-"
        "${dt.month.toString().padLeft(2, '0')}-"
        "${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              const Text(
                "Detail Mutasi",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                "Informasi lengkap riwayat mutasi warga.",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),

              _buildField("ID Warga", data.idWarga),
              const SizedBox(height: 14),

              _buildField("Jenis Mutasi", data.jenisMutasi.isEmpty ? "-" : data.jenisMutasi),
              const SizedBox(height: 14),

              _buildField("Tanggal Mutasi", _fmt(data.tanggal)),
              const SizedBox(height: 14),

              _buildField("Keterangan", data.keterangan.isEmpty ? "-" : data.keterangan),
              const SizedBox(height: 14),

              _buildField("Dibuat Pada", _fmt(data.createdAt)),
              const SizedBox(height: 14),

              _buildField("Terakhir Diupdate", _fmt(data.updatedAt)),
              const SizedBox(height: 14),

              _buildField("UID Dokumen", data.uid),

              const SizedBox(height: 24),

              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: const Text(
                    "Tutup",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      maxLines: label == "Keterangan" ? 3 : 1,
    );
  }
}
