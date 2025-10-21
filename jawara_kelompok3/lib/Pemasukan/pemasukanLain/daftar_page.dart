import 'package:flutter/material.dart';
import '../../Layout/sidebar.dart';
import '../../Theme/app_theme.dart';
import 'detail_dialog.dart';
import 'edit_dialog.dart';

class PemasukanLainDaftarPage extends StatefulWidget {
  const PemasukanLainDaftarPage({super.key});

  @override
  State<PemasukanLainDaftarPage> createState() =>
      _PemasukanLainDaftarPageState();
}

class _PemasukanLainDaftarPageState extends State<PemasukanLainDaftarPage> {
  late List<Map<String, String>> pemasukan;

  @override
  void initState() {
    super.initState();
    pemasukan = [
      {
        "no": "1",
        "nama": "Joki by Firman",
        "jenis": "Pendapatan Lainnya",
        "tanggal": "13 Oktober 2025",
        "nominal": "Rp 49.999.997,00",
      },
      {
        "no": "2",
        "nama": "Tes",
        "jenis": "Pendapatan Lainnya",
        "tanggal": "12 Agustus 2025",
        "nominal": "Rp 10.000,00",
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        title: const Text("Pemasukan Lain - Daftar"),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tombol Filter di atas
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.yellowExtraLight,
                  foregroundColor: AppTheme.yellowDark,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () {},
                icon: const Icon(Icons.filter_alt),
                label: const Text("Filter"),
              ),
            ),
            const SizedBox(height: 16),

            // === Card List seperti di TagihanPage ===
            Expanded(
              child: ListView.builder(
                itemCount: pemasukan.length,
                itemBuilder: (context, index) {
                  final item = pemasukan[index];
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
                          // Header Card (Nama + menu aksi)
                          Row(
                            children: [
                              const Icon(Icons.attach_money,
                                  color: Colors.green),
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
                                      builder: (_) => DetailPemasukanDialog(
                                          pemasukan: item),
                                    );
                                  } else if (value == 'edit') {
                                    final updated =
                                        await showDialog<Map<String, String>>(
                                      context: context,
                                      barrierColor:
                                          Colors.black.withOpacity(0.5),
                                      builder: (_) => EditPemasukanDialog(
                                          pemasukan: item),
                                    );
                                    if (updated != null) {
                                      setState(() {
                                        final i = pemasukan.indexOf(item);
                                        pemasukan[i] = updated;
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

                          // Info baris, gaya sama kayak TagihanPage
                          _buildInfoRow("Jenis Pemasukan", item["jenis"]!),
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

// === Helper Text Builder (sama seperti di TagihanPage) ===
Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600, // label agak bold
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
