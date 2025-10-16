import 'package:flutter/material.dart';
import '../../Layout/sidebar.dart';

class DaftarMutasiPage extends StatelessWidget {
  const DaftarMutasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> mutasi = [
      {
        "no": "1",
        "tanggal": "13 Oktober 2025",
        "keluarga": "Keluarga Firman",
        "jenis": "Mutasi Masuk",
      },
      {
        "no": "2",
        "tanggal": "12 Agustus 2025",
        "keluarga": "Keluarga Siregar",
        "jenis": "Mutasi Keluar",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mutasi Keluarga - Daftar"),
        backgroundColor: const Color(0xFF4B3D1A),
      ),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Tombol Filter
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(12),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF), // ungu
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.filter_alt),
                  label: const Text("Filter"),
                ),
              ),
              // Tabel
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      Colors.grey.shade200,
                    ),
                    columns: const [
                      DataColumn(label: Text("No")),
                      DataColumn(label: Text("Tanggal")),
                      DataColumn(label: Text("Keluarga")),
                      DataColumn(label: Text("Jenis Mutasi")),
                      DataColumn(label: Text("Aksi")),
                    ],
                    rows: mutasi
                        .map(
                          (item) => DataRow(
                            cells: [
                              DataCell(Text(item["no"]!)),
                              DataCell(Text(item["tanggal"]!)),
                              DataCell(Text(item["keluarga"]!)),
                              DataCell(Text(item["jenis"]!)),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.more_horiz),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              // Pagination
              Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: null,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(32, 32),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text("1"),
                    ),
                    IconButton(
                      onPressed: null,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
