import 'package:flutter/material.dart';
import '../../Layout/sidebar.dart';
import '../../Theme/app_theme.dart';

class DaftarbroadcastPage extends StatelessWidget {
  const DaftarbroadcastPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, String>> pengeluaran = [
      {
        "no": "1",
        "nama": "Pembelian ATK",
        "jenis": "Operasional",
        "tanggal": "10 Oktober 2025",
        "nominal": "Rp 500.000,00",
      },
      {
        "no": "2",
        "nama": "Bayar Listrik",
        "jenis": "Utilitas",
        "tanggal": "5 Oktober 2025",
        "nominal": "Rp 1.200.000,00",
      },
    ];

    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        title: const Text("Pengeluaran - Daftar"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
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
                      DataColumn(label: Text("Jenis Pengeluaran")),
                      DataColumn(label: Text("Tanggal")),
                      DataColumn(label: Text("Nominal")),
                      DataColumn(label: Text("Aksi")),
                    ],
                    rows: pengeluaran.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(Text(item["no"]!)),
                          DataCell(Text(item["nama"]!)),
                          DataCell(Text(item["jenis"]!)),
                          DataCell(Text(item["tanggal"]!)),
                          DataCell(Text(item["nominal"]!)),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.more_horiz,
                                  color: theme.iconTheme.color),
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
                      icon: Icon(Icons.chevron_left,
                          color: theme.iconTheme.color),
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
                      icon: Icon(Icons.chevron_right,
                          color: theme.iconTheme.color),
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
