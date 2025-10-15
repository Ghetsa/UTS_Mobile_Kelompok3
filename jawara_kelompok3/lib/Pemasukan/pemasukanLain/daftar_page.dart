import 'package:flutter/material.dart';
import '../../main.dart';

class PemasukanLainDaftarPage extends StatelessWidget {
  const PemasukanLainDaftarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> pemasukan = [
      {
        "no": "1",
        "nama": "Joki by firman",
        "jenis": "Pendapatan Lainnya",
        "tanggal": "13 Oktober 2025",
        "nominal": "Rp 49.999.997,00",
      },
      {
        "no": "2",
        "nama": "tes",
        "jenis": "Pendapatan Lainnya",
        "tanggal": "12 Agustus 2025",
        "nominal": "Rp 10.000,00",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pemasukan Lain - Daftar"),
        backgroundColor: const Color(0xFF4B3D1A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                    headingRowColor: MaterialStateProperty.all(Colors.grey.shade200),
                    columns: const [
                      DataColumn(label: Text("No")),
                      DataColumn(label: Text("Nama")),
                      DataColumn(label: Text("Jenis Pemasukan")),
                      DataColumn(label: Text("Tanggal")),
                      DataColumn(label: Text("Nominal")),
                      DataColumn(label: Text("Aksi")),
                    ],
                    rows: pemasukan
                        .map(
                          (item) => DataRow(
                            cells: [
                              DataCell(Text(item["no"]!)),
                              DataCell(Text(item["nama"]!)),
                              DataCell(Text(item["jenis"]!)),
                              DataCell(Text(item["tanggal"]!)),
                              DataCell(Text(item["nominal"]!)),
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
                    IconButton(onPressed: null, icon: const Icon(Icons.chevron_left)),
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
                    IconButton(onPressed: null, icon: const Icon(Icons.chevron_right)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
