import 'package:flutter/material.dart';
import '../../Theme/app_theme.dart';
import '../../Layout/sidebar.dart';

class DaftarKeluargaPage extends StatelessWidget {
  const DaftarKeluargaPage({super.key});

  final List<Map<String, dynamic>> keluarga = const [
    {
      "namaKeluarga": "Keluarga Varizky Naldiba Rimra",
      "kepalaKeluarga": "Varizky Naldiba Rimra",
      "alamat": "Jl. Ikan Arwana No. 12, Malang",
      "statusKepemilikan": "Pemilik",
      "status": "Aktif"
    },
    {
      "namaKeluarga": "Keluarga Ijat",
      "kepalaKeluarga": "Ijat",
      "alamat": "Keluar Wilayah",
      "statusKepemilikan": "Penyewa",
      "status": "Nonaktif"
    },
    {
      "namaKeluarga": "Keluarga Habibie Ed Dien",
      "kepalaKeluarga": "Habibie Ed Dien",
      "alamat": "Blok A49",
      "statusKepemilikan": "Pemilik",
      "status": "Aktif"
    },
    {
      "namaKeluarga": "Keluarga Farhan",
      "kepalaKeluarga": "Farhan",
      "alamat": "Griyashanta L203",
      "statusKepemilikan": "Pemilik",
      "status": "Aktif"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      appBar: AppBar(
        title: const Text("Daftar Keluarga"),
        backgroundColor: AppTheme.primaryBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_rounded, color: Colors.white),
            tooltip: "Filter Data",
            onPressed: () {},
          ),
        ],
      ),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: keluarga.length,
          itemBuilder: (context, index) {
            final item = keluarga[index];
            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: AppTheme.grayLight,
                  width: 1,
                ),
              ),
              elevation: 1,
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER — Nama Keluarga
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item['namaKeluarga'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert,
                              color: AppTheme.primaryBlue),
                          onSelected: (value) {
                            if (value == 'detail') {
                              debugPrint("Detail: ${item["namaKeluarga"]}");
                            } else if (value == 'edit') {
                              debugPrint("Edit: ${item["namaKeluarga"]}");
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'detail',
                              child: Text('Detail'),
                            ),
                            PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Text(
                      "Kepala Keluarga: ${item['kepalaKeluarga']}",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    Text(
                      "Alamat: ${item['alamat']}",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 10),

                    /// STATUS & KEPEMILIKAN
                    Row(
                      children: [
                        _buildBadge(
                          label: item['statusKepemilikan'],
                          color: AppTheme.primaryBlue,
                          bgColor: AppTheme.blueExtraLight,
                        ),
                        const SizedBox(width: 8),
                        _buildStatusChip(item['status']),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Chip status aktif/nonaktif
  Widget _buildStatusChip(String status) {
    final bool isActive = status.toLowerCase() == "aktif";
    final Color bgColor =
        isActive ? AppTheme.greenExtraLight : AppTheme.redExtraLight;
    final Color textColor =
        isActive ? AppTheme.greenSuperDark : AppTheme.redDark;
    final Color borderColor = isActive ? AppTheme.greenDark : AppTheme.redDark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 0.6),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Badge status kepemilikan
  Widget _buildBadge({
    required String label,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
