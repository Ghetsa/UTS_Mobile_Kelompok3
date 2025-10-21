import 'package:flutter/material.dart';
import '../../layout/sidebar.dart';
import '../../theme/app_theme.dart';
import '../widgets/filter_form.dart';
import 'detail_pengeluaran_dialog.dart';
import 'edit_pengeluaran_dialog.dart';

class SemuaPengeluaranPage extends StatefulWidget {
  const SemuaPengeluaranPage({super.key});

  @override
  State<SemuaPengeluaranPage> createState() => _SemuaPengeluaranPageState();
}

class _SemuaPengeluaranPageState extends State<SemuaPengeluaranPage> {
  final List<Map<String, dynamic>> data = [
    {
      "no": 1,
      "nama": "Pemeliharaan Jalan",
      "jenis": "Pemeliharaan Fasilitas",
      "tanggal": "10 Okt 2025 01:08",
      "nominal": "Rp 2.112,00",
    },
    {
      "no": 2,
      "nama": "Biaya Keamanan",
      "jenis": "Operasional",
      "tanggal": "09 Okt 2025 09:30",
      "nominal": "Rp 1.500.000,00",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Semua Pengeluaran")),
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
                        const FilterFormDialog(title: "Filter Pengeluaran"),
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

            // === Card List View Data Pengeluaran ===
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
                          // === Header: Icon + Nama + Menu ===
                          Row(
                            children: [
                              const Icon(
                                Icons.account_balance_wallet,
                                color: Colors.redAccent,
                              ),
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
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: AppTheme.primaryBlue,
                                ),
                                onSelected: (value) async {
                                  if (value == 'detail') {
                                    await showDialog(
                                      context: context,
                                      builder: (_) => DetailPengeluaranDialog(
                                        pengeluaran: row,
                                      ),
                                    );
                                  } else if (value == 'edit') {
                                    final result = await showDialog<
                                        Map<String, dynamic>>(
                                      context: context,
                                      builder: (_) => EditPengeluaranDialog(
                                        pengeluaran: row,
                                      ),
                                    );

                                    if (result != null) {
                                      setState(() {
                                        data[index] = result;
                                      });
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

                          // === Info Detail Pengeluaran ===
                          _buildInfoRow("Jenis Pengeluaran", row["jenis"]),
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

// 🔹 Helper
Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}
