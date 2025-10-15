import 'package:flutter/material.dart';
import '../../main.dart';

class TagihanPage extends StatelessWidget {
  const TagihanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data = [
      {
        "no": 1,
        "keluarga": "Keluarga Habibie Ed Dien",
        "status": "Aktif",
        "iuran": "Mingguan",
        "kode": "IR175458A501",
        "nominal": "Rp 10,00",
        "periode": "8 Oktober 2025",
        "tagihan": "Belum Dibayar"
      },
      {
        "no": 2,
        "keluarga": "Keluarga Habibie Ed Dien",
        "status": "Aktif",
        "iuran": "Mingguan",
        "kode": "IR185702KX01",
        "nominal": "Rp 10,00",
        "periode": "15 Oktober 2025",
        "tagihan": "Belum Dibayar"
      },
      {
        "no": 3,
        "keluarga": "Keluarga Mara Nunez",
        "status": "Aktif",
        "iuran": "Agustusan",
        "kode": "IR2244069O01",
        "nominal": "Rp 15,00",
        "periode": "10 Oktober 2025",
        "tagihan": "Belum Dibayar"
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Tagihan")),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 600; // cek layar lebar/kecil

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tombol responsive
                if (isWide)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.filter_alt),
                        label: const Text("Filter"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text("Cetak PDF"),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.filter_alt),
                        label: const Text("Filter"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text("Cetak PDF"),
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                // Tabel dengan scroll horizontal
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
                      columns: const [
                        DataColumn(label: Text("No")),
                        DataColumn(label: Text("Nama Keluarga")),
                        DataColumn(label: Text("Status Keluarga")),
                        DataColumn(label: Text("Iuran")),
                        DataColumn(label: Text("Kode Tagihan")),
                        DataColumn(label: Text("Nominal")),
                        DataColumn(label: Text("Periode")),
                        DataColumn(label: Text("Status")),
                        DataColumn(label: Text("Aksi")),
                      ],
                      rows: data.map((row) {
                        return DataRow(
                          cells: [
                            DataCell(Text(row["no"].toString())),
                            DataCell(Text(row["keluarga"])),
                            DataCell(
                              Chip(
                                label: Text(row["status"]),
                                backgroundColor: Colors.green[50],
                                labelStyle: const TextStyle(color: Colors.green),
                              ),
                            ),
                            DataCell(Text(row["iuran"])),
                            DataCell(Text(row["kode"])),
                            DataCell(Text(row["nominal"])),
                            DataCell(Text(row["periode"])),
                            DataCell(
                              Chip(
                                label: Text(row["tagihan"]),
                                backgroundColor: Colors.yellow[100],
                                labelStyle: const TextStyle(color: Colors.orange),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
