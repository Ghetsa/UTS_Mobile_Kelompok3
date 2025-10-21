import 'package:flutter/material.dart';
import '../../Layout/sidebar.dart';
import '../../theme/app_theme.dart';
import 'widgets/filter_tagihan.dart';
import 'detail_tagihan_page.dart';
import 'edit_tagihan_page.dart';

class TagihanPage extends StatelessWidget {
  const TagihanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data = [
      {
        "no": 1,
        "keluarga": "Keluarga Habibie Ed Dien",
        "status": "Aktif",
        "iuran": "Mingguan",
        "kode": "IR175458A501",
        "nominal": "Rp 10,00",
        "periode": "8 Oktober 2025",
        "tagihan": "Belum Dibayar"
      },
      {
        "no": 2,
        "keluarga": "Keluarga Habibie Ed Dien",
        "status": "Aktif",
        "iuran": "Mingguan",
        "kode": "IR185702KX01",
        "nominal": "Rp 10,00",
        "periode": "15 Oktober 2025",
        "tagihan": "Belum Dibayar"
      },
      {
        "no": 3,
        "keluarga": "Keluarga Mara Nunez",
        "status": "Aktif",
        "iuran": "Agustusan",
        "kode": "IR2244069O01",
        "nominal": "Rp 15,00",
        "periode": "10 Oktober 2025",
        "tagihan": "Belum Dibayar"
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Tagihan")),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tombol atas (Filter & Cetak)
            LayoutBuilder(
              builder: (context, constraints) {
                final filterButton = ElevatedButton.icon(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => const FilterTagihanDialog(),
                    );
                    if (result != null) {
                      debugPrint("Filter dipilih: $result");
                    }
                  },
                  icon: const Icon(Icons.filter_alt, color: AppTheme.yellowDark),
                  label: const Text("Filter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.yellowExtraLight,
                    foregroundColor: AppTheme.yellowDark,
                  ),
                );

                final cetakButton = ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.picture_as_pdf,
                      color: AppTheme.redDark),
                  label: const Text("Cetak",style: TextStyle(color: AppTheme.redDark),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppTheme.redExtraLight,
    
                  ),
                );

                return constraints.maxWidth > 600
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          filterButton,
                          const SizedBox(width: 12),
                          cetakButton,
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          filterButton,
                          const SizedBox(height: 8),
                          cetakButton,
                        ],
                      );
              },
            ),

            const SizedBox(height: 16),

            // === Card List View Data Tagihan ===
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final row = data[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 0, // 🔹 Hilangkan bayangan
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.grey.shade300, // 🔹 Border abu muda
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: Nama Keluarga + menu aksi
                          Row(
                            children: [
                              const Icon(Icons.family_restroom,
                                  color: Colors.blue),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  row["keluarga"],
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
                                          DetailTagihanDialog(tagihan: row),
                                    );
                                  } else if (value == 'edit') {
                                    final result =
                                        await showDialog<Map<String, dynamic>>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) =>
                                          EditTagihanDialog(tagihan: row),
                                    );
                                    if (result != null) {
                                      debugPrint("Tagihan diperbarui: $result");
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

                          // Info baris
                          _buildInfoRow("Iuran", row["iuran"]),
                          _buildInfoRow("Kode", row["kode"]),
                          _buildInfoRow("Nominal", row["nominal"]),
                          _buildInfoRow("Periode", row["periode"]),
                          _buildInfoRow("Status Keluarga", row["status"]),
                          _buildInfoRow("Tagihan", row["tagihan"]),
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

// === Helper Widget ===
Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600, // label bold
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontWeight: FontWeight.normal, // value normal
            ),
          ),
        ],
      ),
    ),
  );
}
