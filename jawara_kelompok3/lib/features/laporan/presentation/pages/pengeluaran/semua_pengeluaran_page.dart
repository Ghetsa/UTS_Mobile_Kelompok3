import 'package:flutter/material.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../widgets/dialog/detail_pengeluaran_dialog.dart';
import '../../widgets/dialog/edit_pengeluaran_dialog.dart';
import '../../widgets/card/pengeluaran_card.dart';

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
      backgroundColor: AppTheme.backgroundBlueWhite,
      appBar: AppBar(title: const Text("Semua Pengeluaran")),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_alt, color: Colors.white),
                  label: const Text("Filter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.yellowDark,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final row = data[index];
                  return PengeluaranCard(
                    data: row,
                    onDetail: () async {
                      await showDialog(
                        context: context,
                        builder: (_) => DetailPengeluaranDialog(pengeluaran: row),
                      );
                    },
                    onEdit: () async {
                      final result = await showDialog<Map<String, dynamic>>(
                        context: context,
                        builder: (_) => EditPengeluaranDialog(pengeluaran: row),
                      );

                      if (result != null) {
                        setState(() {
                          data[index] = result;
                        });
                      }
                    },
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