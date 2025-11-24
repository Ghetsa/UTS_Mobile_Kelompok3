import 'package:flutter/material.dart';
import '../../../../../../core/layout/header.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import 'detailPengeluaran.dart';
import 'editPengeluaran.dart';

class PengeluaranDaftarPage extends StatefulWidget {
  const PengeluaranDaftarPage({super.key});

  @override
  State<PengeluaranDaftarPage> createState() => _PengeluaranDaftarPageState();
}

class _PengeluaranDaftarPageState extends State<PengeluaranDaftarPage> {
  late List<Map<String, String>> pengeluaran;

  @override
  void initState() {
    super.initState();
    pengeluaran = [
      {
        "no": "1",
        "nama": "Pembelian ATK",
        "jenis": "Operasional",
        "tanggal": "13 Oktober 2025",
        "nominal": "Rp 500.000,00",
      },
      {
        "no": "2",
        "nama": "Perawatan Kantor",
        "jenis": "Perawatan",
        "tanggal": "12 Agustus 2025",
        "nominal": "Rp 1.000.000,00",
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        title: const Text("Daftar Pengeluaran"),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tombol Filter
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.yellowDark,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () {},
                icon: const Icon(Icons.filter_alt),
                label: const Text("Filter"),
              ),
            ),
            const SizedBox(height: 16),

            // === Daftar Card Pengeluaran ===
            Expanded(
              child: ListView.builder(
                itemCount: pengeluaran.length,
                itemBuilder: (context, index) {
                  final item = pengeluaran[index];
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
                          // Header Card (Nama + Menu Aksi)
                          Row(
                            children: [
                              const Icon(Icons.money_off, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item["nama"]!,
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
                                    showDialog(
                                      context: context,
                                      barrierColor:
                                          Colors.black.withOpacity(0.5),
                                      builder: (_) => DetailPengeluaranDialog(
                                          pengeluaran: item),
                                    );
                                  } else if (value == 'edit') {
                                    final updated =
                                        await showDialog<Map<String, String>>(
                                      context: context,
                                      barrierColor:
                                          Colors.black.withOpacity(0.5),
                                      builder: (_) => EditPengeluaranDialog(
                                          pengeluaran: item),
                                    );
                                    if (updated != null) {
                                      setState(() {
                                        final i = pengeluaran.indexOf(item);
                                        pengeluaran[i] = updated;
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
                                        Text("Lihat Detail"),
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

                          // Info Detail
                          _buildInfoRow("Jenis Pengeluaran", item["jenis"]!),
                          _buildInfoRow("Tanggal", item["tanggal"]!),
                          _buildInfoRow("Nominal", item["nominal"]!),
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

// === Helper Text Builder ===
Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    ),
  );
}
