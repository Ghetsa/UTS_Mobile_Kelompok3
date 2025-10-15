import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../layout/sidebar.dart';
import '../widgets/info_box.dart';

class KategoriIuranPage extends StatelessWidget {
  const KategoriIuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> dataIuran = [
      {
        "no": "1",
        "nama": "Mingguan",
        "jenis": "Iuran Khusus",
        "nominal": "Rp 10,000",
      },
      {
        "no": "2",
        "nama": "Agustusan",
        "jenis": "Iuran Khusus",
        "nominal": "Rp 15,000",
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

            /// Tombol navigasi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/pemasukan/pages/tambah_kategori');
                  },
                  icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                  label: const Text("Tambah"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/pemasukan/pages/detail_kategori');
                  },
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  label: const Text("Filter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Tabel Data
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(AppTheme.lightBlue),
                  dataRowColor: WidgetStateProperty.all(Colors.white),
                  columns: const [
                    DataColumn(label: Text("No", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Nama Iuran", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Jenis Iuran", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Nominal", style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text("Aksi", style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: dataIuran.map((row) {
                    return DataRow(
                      cells: [
                        DataCell(Text(row["no"]!)),
                        DataCell(Text(row["nama"]!)),
                        DataCell(Text(row["jenis"]!)),
                        DataCell(Text(row["nominal"]!)),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.more_vert, color: AppTheme.primaryBlue),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/pemasukan/pages/detail_kategori',
                                arguments: row,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
