import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../layout/sidebar.dart';
import '../widgets/info_box.dart';
import '../widgets/filter_kategori_iuran.dart';

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

            /// Tombol navigasi responsif
            LayoutBuilder(
              builder: (context, constraints) {
                final addButton = ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, '/pemasukan/pages/tambah_kategori');
                  },
                  icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                  label: const Text("Tambah"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );

                final filterButton = ElevatedButton.icon(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => const FilterKategoriIuranDialog(),
                    );

                    if (result != null) {
                      debugPrint("Filter dipilih: $result");
                      // TODO: terapkan filter ke tabel sesuai jenis iuran
                    }
                  },
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  label: const Text("Filter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );

                if (constraints.maxWidth > 600) {
                  // layar besar → tombol sejajar kanan atas
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      addButton,
                      const SizedBox(width: 12),
                      filterButton,
                    ],
                  );
                } else {
                  // layar kecil → tombol ke tengah atas (stacked)
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      addButton,
                      const SizedBox(height: 8),
                      filterButton,
                    ],
                  );
                }
              },
            ),

            const SizedBox(height: 16),

            /// Tabel Data Responsif
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: constraints.maxWidth),
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(AppTheme.lightBlue),
                          dataRowColor: WidgetStateProperty.all(Colors.white),
                          columns: const [
                            DataColumn(
                              label: Text("No",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            DataColumn(
                              label: Text("Nama Iuran",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            DataColumn(
                              label: Text("Jenis Iuran",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            DataColumn(
                              label: Text("Nominal",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            DataColumn(
                              label: Text("Aksi",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
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
                                    icon: const Icon(Icons.more_vert,
                                        color: AppTheme.primaryBlue),
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
