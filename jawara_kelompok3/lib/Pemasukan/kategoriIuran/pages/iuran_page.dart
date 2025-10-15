import 'package:flutter/material.dart';
import '../../../main.dart';
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
        backgroundColor: const Color(0xFF2D531A),
        foregroundColor: const Color(0xFFEBDDD0),
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
                  icon: const Icon(Icons.add_circle_outline,
                      color: Color(0xFFEBDDD0)),
                  label: const Text("Tambah"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D531A),
                    foregroundColor: const Color(0xFFEBDDD0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/pemasukan/pages/detail_kategori');
                  },
                  icon: const Icon(Icons.filter_list,
                      color: Color(0xFFEBDDD0)),
                  label: const Text("Filter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D531A),
                    foregroundColor: const Color(0xFFEBDDD0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
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
                  columns: const [
                    DataColumn(label: Text("No")),
                    DataColumn(label: Text("Nama Iuran")),
                    DataColumn(label: Text("Jenis Iuran")),
                    DataColumn(label: Text("Nominal")),
                    DataColumn(label: Text("Aksi")),
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
                            icon: const Icon(Icons.more_vert),
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
