import 'package:flutter/material.dart';
import '../../Layout/sidebar.dart';
import '../../Theme/app_theme.dart';
import 'detailKegiatan.dart'; // ← Tambahkan import ini

class DaftarkegiatanPage extends StatelessWidget {
  const DaftarkegiatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Data kegiatan contoh
    final List<Map<String, String>> kegiatan = [
      {
        "no": "1",
        "nama": "Musyawarah RT",
        "kategori": "Komunitas & Sosial",
        "pj": "Pak RT",
        "tanggal": "12 Oktober 2025",
        "lokasi": "Balai RT 03",
        "deskripsi":
            "Rapat koordinasi rutin warga membahas kegiatan sosial dan keamanan lingkungan.",
      },
      {
        "no": "2",
        "nama": "Senam Pagi Bersama",
        "kategori": "Kesehatan & Olahraga",
        "pj": "Bu RW",
        "tanggal": "20 Oktober 2025",
        "lokasi": "Lapangan RW 05",
        "deskripsi":
            "Kegiatan olahraga bersama warga untuk menjaga kesehatan dan mempererat silaturahmi.",
      },
    ];

    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        title: const Text("Kegiatan - Daftar"),
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
                      DataColumn(label: Text("Nama Kegiatan")),
                      DataColumn(label: Text("Kategori")),
                      DataColumn(label: Text("Penanggung Jawab")),
                      DataColumn(label: Text("Tanggal Pelaksanaan")),
                      DataColumn(label: Text("Aksi")),
                    ],
                    rows: kegiatan.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(Text(item["no"]!)),
                          DataCell(Text(item["nama"]!)),
                          DataCell(Text(item["kategori"]!)),
                          DataCell(Text(item["pj"]!)),
                          DataCell(Text(item["tanggal"]!)),
                          DataCell(
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == "detail") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailKegiatanPage(data: item),
                                    ),
                                  );
                                } else if (value == "edit") {
                                  // TODO: Navigasi ke halaman edit
                                } else if (value == "hapus") {
                                  // TODO: Logika hapus data
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                    value: "detail", child: Text("Detail")),
                                const PopupMenuItem(
                                    value: "edit", child: Text("Edit")),
                                const PopupMenuItem(
                                    value: "hapus", child: Text("Hapus")),
                              ],
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
