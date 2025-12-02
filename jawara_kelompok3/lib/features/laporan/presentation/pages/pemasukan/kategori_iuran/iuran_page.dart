import 'package:flutter/material.dart';
import '../../../../../../core/layout/sidebar.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../widgets/info_box.dart';
import '../../../widgets/filter/kategori_iuran_filter.dart';
import '../../../widgets/card/kategori_iuran_card.dart';

class KategoriIuranPage extends StatelessWidget {
  const KategoriIuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> dataIuran = [
      {"no": "1", "nama": "Mingguan", "jenis": "Iuran Khusus", "nominal": "10000"},
      {"no": "2", "nama": "Agustusan", "jenis": "Iuran Khusus", "nominal": "15000"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Kategori Iuran")),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InfoBox(),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => const FilterKategoriIuranDialog(),
                    );
                    if (result != null) debugPrint("Filter dipilih: $result");
                  },
                  icon: const Icon(Icons.filter_alt, color: Colors.white),
                  label: const Text("Filter", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.yellowMediumDark,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/pemasukan/pages/tambah_kategori'),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text("Tambah", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.greenDark),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: dataIuran.length,
                itemBuilder: (_, index) => KategoriIuranCard(row: dataIuran[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
