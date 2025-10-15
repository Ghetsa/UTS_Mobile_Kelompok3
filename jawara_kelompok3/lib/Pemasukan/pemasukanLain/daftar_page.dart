import 'package:flutter/material.dart';
import '../../Layout/sidebar.dart';
import '../../Theme/app_theme.dart'; // pastikan path benar

class PemasukanLainDaftarPage extends StatelessWidget {
  const PemasukanLainDaftarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, String>> pemasukan = [
      {
        "no": "1",
        "nama": "Joki by Firman",
        "jenis": "Pendapatan Lainnya",
        "tanggal": "13 Oktober 2025",
        "nominal": "Rp 49.999.997,00",
      },
      {
        "no": "2",
        "nama": "Tes",
        "jenis": "Pendapatan Lainnya",
        "tanggal": "12 Agustus 2025",
        "nominal": "Rp 10.000,00",
      },
    ];

    return Scaffold(
      drawer: const AppSidebar(), // Sidebar ditampilkan lewat tombol menu
      appBar: AppBar(
        title: const Text("Pemasukan Lain - Daftar"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) => // tombol menu sidebar (☰)
              IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              // Tombol Filter
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(12),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
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
                    headingRowColor: MaterialStatePropertyAll(
                      theme.colorScheme.secondary.withOpacity(0.2),
                    ),
                    columns: const [
                      DataColumn(label: Text("No")),
                      DataColumn(label: Text("Nama")),
                      DataColumn(label: Text("Jenis Pemasukan")),
                      DataColumn(label: Text("Tanggal")),
                      DataColumn(label: Text("Nominal")),
                      DataColumn(label: Text("Aksi")),
                    ],
                    rows: pemasukan.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(Text(item["no"]!)),
                          DataCell(Text(item["nama"]!)),
                          DataCell(Text(item["jenis"]!)),
                          DataCell(Text(item["tanggal"]!)),
                          DataCell(Text(item["nominal"]!)),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.more_horiz, color: theme.iconTheme.color),
                              onPressed: () {
                                // aksi lain (edit/detail) bisa ditambahkan di sini
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Pagination
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: null,
                      icon: Icon(Icons.chevron_left, color: theme.iconTheme.color),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(32, 32),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text("1"),
                    ),
                    IconButton(
                      onPressed: null,
                      icon: Icon(Icons.chevron_right, color: theme.iconTheme.color),
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
