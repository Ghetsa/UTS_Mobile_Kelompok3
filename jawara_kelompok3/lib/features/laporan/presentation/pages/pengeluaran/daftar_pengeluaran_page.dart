import 'package:flutter/material.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../widgets/dialog/detail_pengeluaran_lain_dialog.dart';
import '../../widgets/dialog/edit_pengeluaran_lain_dialog.dart';
import '../../widgets/card/pengeluaran_card.dart';

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
      backgroundColor: AppTheme.backgroundBlueWhite,
      drawer: const AppSidebar(),
      appBar: AppBar(
        title: const Text("Daftar Pengeluaran"),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
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
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: pengeluaran.length,
                itemBuilder: (context, index) {
                  final item = pengeluaran[index];
                  return PengeluaranCard(
                    data: item,
                    onDetail: () {
                      showDialog(
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.5),
                        builder: (_) => DetailPengeluaranDialog(pengeluaran: item),
                      );
                    },
                    onEdit: () async {
                      final updated = await showDialog<Map<String, String>>(
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.5),
                        builder: (_) => EditPengeluaranDialog(pengeluaran: item),
                      );
                      if (updated != null) {
                        setState(() {
                          final i = pengeluaran.indexOf(item);
                          pengeluaran[i] = updated;
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