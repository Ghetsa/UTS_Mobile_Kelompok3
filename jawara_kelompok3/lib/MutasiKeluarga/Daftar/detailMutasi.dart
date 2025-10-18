import 'package:flutter/material.dart';
import '../mutasi_model.dart';
import '../../Layout/sidebar.dart';

class DetailMutasiPage extends StatelessWidget {
  final Mutasi mutasi;
  const DetailMutasiPage({super.key, required this.mutasi});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Mutasi Warga"),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Text(
                  "Detail Mutasi Warga",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                _buildDetailItem("Keluarga", mutasi.keluarga),
                _buildDetailItem("Alamat Lama", "Belum diatur"),
                _buildDetailItem("Alamat Baru", "-"),
                _buildDetailItem(
                  "Tanggal Mutasi",
                  "${mutasi.tanggal.day} ${_getNamaBulan(mutasi.tanggal.month)} ${mutasi.tanggal.year}",
                ),
                _buildDetailItem("Jenis Mutasi", mutasi.jenis),
                _buildDetailItem("Alasan", mutasi.alasan),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title:",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }

  String _getNamaBulan(int bulan) {
    const bulanMap = [
      "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    ];
    return bulanMap[bulan - 1];
  }
}
