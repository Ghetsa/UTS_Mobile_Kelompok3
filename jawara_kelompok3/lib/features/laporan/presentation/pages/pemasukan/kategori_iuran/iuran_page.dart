import 'package:flutter/material.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../widgets/info_box.dart';
import '../../../widgets/filter/kategori_iuran_filter.dart';
import 'edit_kategori_page.dart';
import 'detail_kategori_page.dart';

class KategoriIuranPage extends StatelessWidget {
  const KategoriIuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> dataIuran = [
      {
        "no": "1",
        "nama": "Mingguan",
        "jenis": "Iuran Khusus",
        "nominal": "10000",
      },
      {
        "no": "2",
        "nama": "Agustusan",
        "jenis": "Iuran Khusus",
        "nominal": "15000",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kategori Iuran"),
      ),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InfoBox(),
            const SizedBox(height: 16),

            // === Tombol Tambah & Filter ===
            LayoutBuilder(
              builder: (context, constraints) {
                final filterButton = ElevatedButton.icon(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => const FilterKategoriIuranDialog(),
                    );
                    if (result != null) {
                      debugPrint("Filter dipilih: $result");
                    }
                  },
                  icon: const Icon(Icons.filter_alt, color: Colors.white),
                  label: const Text(
                    "Filter",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.yellowMediumDark,
                    foregroundColor: Colors.white,
                  ),
                );

                final tambahButton = ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/pemasukan/pages/tambah_kategori',
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "Tambah",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppTheme.greenDark,
                  ),
                );

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    filterButton,
                    tambahButton,
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            // === Card List View Data Iuran (model tampilan seperti Tagihan) ===
            Expanded(
              child: ListView.builder(
                itemCount: dataIuran.length,
                itemBuilder: (context, index) {
                  final row = dataIuran[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 0, // 🔹 tanpa bayangan
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.grey.shade300, // 🔹 border abu muda
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔹 Header: nama iuran dan menu aksi
                          Row(
                            children: [
                              const Icon(Icons.category, color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  row["nama"]!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert,
                                    color: AppTheme.primaryBlue),
                                onSelected: (value) async {
                                  if (value == 'detail') {
                                    await showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) =>
                                          DetailKategoriDialog(kategori: row),
                                    );
                                  } else if (value == 'edit') {
                                    final result =
                                        await showDialog<Map<String, String>>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) =>
                                          EditIuranDialog(iuran: row),
                                    );
                                    if (result != null) {
                                      debugPrint(
                                          "Data iuran diperbarui: $result");
                                    }
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

                          const SizedBox(height: 12),

                          // 🔹 Info baris tanpa icon, label bold ringan
                          _buildInfoRow("Jenis Iuran", row["jenis"]!),
                          _buildInfoRow("Nominal", "Rp ${row["nominal"]},00"),
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
}

// === Helper Info Row ===
Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600, // label sedikit tebal
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontWeight: FontWeight.normal, // isi font biasa
            ),
          ),
        ],
      ),
    ),
  );
}
