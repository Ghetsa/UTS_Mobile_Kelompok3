import 'package:flutter/material.dart';
import '../widgets/info_box.dart';
import '../../main.dart';

class IuranPage extends StatelessWidget {
  const IuranPage({super.key});

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
      appBar: AppBar(title: const Text("Daftar Iuran")),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InfoBox(),
            const SizedBox(height: 16),

            // Tombol navigasi
            // Tombol navigasi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/tambah');
                  },
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Color(0xFFEBDDD0),
                  ),
                  label: const Text("Tambah"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D531A), 
                    foregroundColor: const Color(
                      0xFFEBDDD0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list, color: Color(0xFFEBDDD0)),
                  label: const Text("Filter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D531A),
                    foregroundColor: const Color(
                      0xFFEBDDD0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Tabel Data
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
                                '/detail',
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
