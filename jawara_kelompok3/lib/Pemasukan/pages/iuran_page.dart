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
      appBar: AppBar(
        title: const Text("Daftar Iuran"),
        backgroundColor: const Color(0xFF1E3A8A), // biru navy modern
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: const AppSidebar(),
      backgroundColor: const Color(0xFFF8FAFC), // putih kebiruan lembut
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InfoBox(),
            const SizedBox(height: 16),

            // 🔹 Tombol Navigasi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/tambah');
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text("Tambah"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB), // biru terang
                    foregroundColor: Colors.white, // teks putih
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list),
                  label: const Text("Filter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 🔹 Tabel Data
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      const Color(0xFFDBEAFE), // biru muda lembut untuk header
                    ),
                    dataRowColor: MaterialStateProperty.all(
                      Colors.white,
                    ),
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
                          DataCell(Text(row["no"]!, style: const TextStyle(color: Color(0xFF1E293B)))),
                          DataCell(Text(row["nama"]!, style: const TextStyle(color: Color(0xFF1E293B)))),
                          DataCell(Text(row["jenis"]!, style: const TextStyle(color: Color(0xFF1E293B)))),
                          DataCell(Text(row["nominal"]!, style: const TextStyle(color: Color(0xFF1E293B)))),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.more_vert, color: Color(0xFF1E3A8A)),
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
            ),
          ],
        ),
      ),
    );
  }
}
