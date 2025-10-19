import 'package:flutter/material.dart';
import '../../Layout/sidebar.dart'; // Menggunakan path sidebar Anda
import '../../Theme/app_theme.dart'; // Menggunakan path theme Anda

class DaftarChannelPage extends StatelessWidget {
  const DaftarChannelPage({super.key});

  // Data sesuai dengan gambar Daftar Channel Transfer
  final List<Map<String, String>> channelData = const [
    {
      'no': '1',
      'nama': '234234',
      'tipe': 'ewallet',
      'a/n': '23234',
      'thumbnail': '-',
      'aksi': '...'
    },
    {
      'no': '2',
      'nama': 'Transfer via BCA',
      'tipe': 'bank',
      'a/n': 'RT Jawara Karangploso',
      'thumbnail': '-',
      'aksi': '...'
    },
    {
      'no': '3',
      'nama': 'Gopay Ketua RT',
      'tipe': 'ewallet',
      'a/n': 'Budi Santoso',
      'thumbnail': '-',
      'aksi': '...'
    },
    {
      'no': '4',
      'nama': 'QRIS Resmi RT 08',
      'tipe': 'qris',
      'a/n': 'RW 08 Karangploso',
      'thumbnail': '-',
      'aksi': '...'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Struktur Scaffold meniru PemasukanLainDaftarPage
    return Scaffold(
      // Drawer: Menggunakan AppSidebar (sesuai struktur Anda)
      drawer: const AppSidebar(),

      // AppBar: Dibuat manual seperti kode Anda, tanpa import AppHeader eksplisit
      appBar: AppBar(
        title: const Text("Channel Transfer - Daftar"),
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
        // Menambahkan Actions yang biasa ada di Header Anda (asumsi)
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),

      // Body: Padding -> Card -> Column (sesuai PemasukanLainDaftarPage)
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          color: theme.colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              // Tombol Tambah Channel (Menggantikan Tombol Filter)
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
                  onPressed: () {
                    // Navigasi ke rute Tambah Channel (misalnya: '/channel/tambah')
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Tambah Channel"),
                ),
              ),

              // Tabel
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    // Style Header Sesuai Gambar
                    headingRowColor: MaterialStatePropertyAll(
                      AppTheme
                          .backgroundBlueWhite, // Menggunakan warna dari AppTheme Anda
                    ),
                    headingTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                      fontSize: 14,
                    ),
                    dataRowMinHeight: 48,
                    dataRowMaxHeight: 48,
                    columns: const [
                      DataColumn(label: Text("NO")),
                      DataColumn(label: Text("NAMA")),
                      DataColumn(label: Text("TIPE")),
                      DataColumn(label: Text("A/N")),
                      DataColumn(label: Text("THUMBNAIL")),
                      DataColumn(label: Text("AKSI")),
                    ],
                    rows: channelData.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(Text(item["no"]!)),
                          DataCell(Text(item["nama"]!)),
                          DataCell(Text(item["tipe"]!)),
                          DataCell(Text(item["a/n"]!)),
                          DataCell(Text(item["thumbnail"]!)),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.more_horiz,
                                  color: theme.iconTheme.color),
                              onPressed: () {
                                // Aksi lainnya
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Pagination (Sesuai PemasukanLainDaftarPage)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      child: const Text("1"),
                    ),
                    IconButton(
                      onPressed: () {},
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
