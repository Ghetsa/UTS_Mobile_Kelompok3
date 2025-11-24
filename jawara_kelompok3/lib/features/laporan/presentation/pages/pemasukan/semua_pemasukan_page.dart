import 'package:flutter/material.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/filter_form.dart';
import 'detail_pemasukan_dialog.dart';
import 'edit_pemasukan_dialog.dart';

class SemuaPemasukanPage extends StatelessWidget {
  const SemuaPemasukanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data = [
      {
        "no": 1,
        "nama": "Joki by Firman",
        "jenis": "Pendapatan Lainnya",
        "tanggal": "13 Okt 2025 00:55",
        "nominal": "Rp 49.999.997,00",
      },
      {
        "no": 2,
        "nama": "Tes",
        "jenis": "Pendapatan Lainnya",
        "tanggal": "12 Agt 2025 13:26",
        "nominal": "Rp 10.000,00",
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Semua Pemasukan")),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Tombol Filter
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) =>
                        const FilterFormDialog(title: "Filter Pemasukan"),
                  );
                },
                icon: const Icon(Icons.filter_alt, color: Colors.white),
                label: const Text("Filter"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.yellowDark,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // === Card List View Data Pemasukan ===
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final row = data[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // === Header: Nama + menu aksi ===
                          Row(
                            children: [
                              const Icon(Icons.attach_money,
                                  color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  row["nama"],
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
                                      barrierDismissible:
                                          true, // bisa ditutup dengan tap luar
                                      builder: (context) =>
                                          DetailPemasukanDialog(pemasukan: row),
                                    );
                                  } else if (value == 'edit') {
                                    final result =
                                        await showDialog<Map<String, dynamic>>(
                                      context: context,
                                      barrierDismissible:
                                          false, // biar user harus tekan Simpan/Batal
                                      builder: (context) =>
                                          EditPemasukanDialog(pemasukan: row),
                                    );
                                    if (result != null) {
                                      debugPrint(
                                          "Data pemasukan diperbarui: $result");
                                      // Di sini nanti bisa ditambah update state (kalau page diubah jadi Stateful)
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

                          // === Info Detail Pemasukan ===
                          _buildInfoRow("Jenis Pemasukan", row["jenis"]),
                          _buildInfoRow("Tanggal", row["tanggal"]),
                          _buildInfoRow("Nominal", row["nominal"]),
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

// 🔹 Helper: buat label dan value info
Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600, // label agak tebal
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontWeight: FontWeight.normal, // isi normal
            ),
          ),
        ],
      ),
    ),
  );
}
