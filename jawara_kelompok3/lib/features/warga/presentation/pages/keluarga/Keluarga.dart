import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/layout/sidebar.dart';
import '../../../../../core/widgets/filter_keluarga.dart'; // pastikan file dialog sudah ada
import 'DetailKeluarga.dart';
import 'EditKeluarga.dart';

class DaftarKeluargaPage extends StatelessWidget {
  const DaftarKeluargaPage({super.key});

  final List<Map<String, dynamic>> keluarga = const [
    {
      "namaKeluarga": "Keluarga Syahrul Gunawan",
      "kepalaKeluarga": "Muhammad Syahrul Gunawan",
      "alamat": "Jl. Ikan Arwana No. 12, Malang",
      "statusKepemilikan": "Pemilik",
      "status": "Aktif"
    },
    {
      "namaKeluarga": "Keluarga Oltha Rosyeda",
      "kepalaKeluarga": "Oltha Rosyeda",
      "alamat": "Keluar Wilayah",
      "statusKepemilikan": "Penyewa",
      "status": "Nonaktif"
    },
    {
      "namaKeluarga": "Keluarga Luthfi Triaswangga",
      "kepalaKeluarga": "Luthfi Triaswangga",
      "alamat": "Blok A49",
      "statusKepemilikan": "Pemilik",
      "status": "Aktif"
    },
    {
      "namaKeluarga": "Keluarga Ghetsa Ramadhani",
      "kepalaKeluarga": "Ghetsa Ramadhani",
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
      ),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Tombol Filter dan Cetak
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => const FilterKeluargaDialog(),
                    );
                    if (result != null) {
                      debugPrint("Filter diterapkan: $result");
                    }
                  },
                  icon: const Icon(Icons.filter_alt, color: Colors.white),
                  label: const Text("Filter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.yellowMediumDark,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    debugPrint("Cetak daftar keluarga ke PDF...");
                  },
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                  label: const Text("Cetak",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.redDark,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// 🔹 List Daftar Keluarga
            Expanded(
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
                    elevation: 0,
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
                                    fontSize: 17,
                                    color: AppTheme.blueDark,
                                  ),
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert,
                                    color: AppTheme.primaryBlue),
                                onSelected: (value) {
                                  if (value == 'detail') {
                                    showDialog(
                                      context: context,
                                      builder: (_) =>
                                          DetailKeluargaDialog(keluarga: item),
                                    );
                                  } else if (value == 'edit') {
                                    showDialog(
                                      context: context,
                                      builder: (_) =>
                                          EditKeluargaDialog(keluarga: item),
                                    );
                                  }
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem(
                                    value: 'detail',
                                    child: Row(
                                      children: [
                                        Icon(Icons.visibility,
                                            color: Colors.blue),
                                        SizedBox(width: 8),
                                        Text("Detail"),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, color: Colors.orange),
                                        SizedBox(width: 8),
                                        Text("Edit"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 4),
                          Text(
                            "Kepala Keluarga: ${item['kepalaKeluarga']}",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                          ),
                          Text(
                            "Alamat: ${item['alamat']}",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
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
          ],
        ),
      ),
    );
  }

  /// 🔹 Chip status aktif/nonaktif
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

  /// 🔹 Badge status kepemilikan
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
