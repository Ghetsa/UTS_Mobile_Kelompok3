import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/pesan_warga_model.dart';

class DetailAspirasi extends StatelessWidget {
  final PesanWargaModel model;

  const DetailAspirasi({super.key, required this.model});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Diterima':
        return AppTheme.greenMediumDark;
      case 'Pending':
        return AppTheme.yellowMediumDark;
      case 'Ditolak':
        return AppTheme.redMedium;
      default:
        return AppTheme.hitam;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        title:
            const Text("Detail Aspirasi", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 6,
          shadowColor: AppTheme.blueExtraLight,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Detail Aspirasi",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                _buildRow("ID Pesan", model.idPesan),
                const SizedBox(height: 12),

                _buildRow("Isi Pesan", model.isiPesan),
                const SizedBox(height: 12),

                _buildRow("Kategori", model.kategori),
                const SizedBox(height: 12),

                _buildRow(
                  "Status",
                  model.status,
                  color: _getStatusColor(model.status),
                ),
                const SizedBox(height: 12),

                _buildRow(
                  "Tanggal Dibuat",
                  model.createdAt?.toString() ?? "-",
                ),
                const SizedBox(height: 12),

                _buildRow(
                  "Terakhir Update",
                  model.updatedAt?.toString() ?? "-",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label:",
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue)),
        const SizedBox(height: 6),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.backgroundBlueWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.blueLight),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: color ?? AppTheme.hitam,
              fontWeight: color != null ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
