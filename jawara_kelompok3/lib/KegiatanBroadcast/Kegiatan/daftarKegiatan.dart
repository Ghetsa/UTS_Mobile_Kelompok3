import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../Layout/sidebar.dart';

class DaftarKegiatanPage extends StatefulWidget {
  const DaftarKegiatanPage({super.key});

  @override
  State<DaftarKegiatanPage> createState() => _DaftarKegiatanPageState();
}

class _DaftarKegiatanPageState extends State<DaftarKegiatanPage> {
  List<Map<String, String>> kegiatanList = [
    {
      "judul": "Kerja Bakti Mingguan",
      "tanggal": "12 Oktober 2025",
      "lokasi": "Balai RW 05",
      "keterangan": "Membersihkan area taman dan saluran air.",
    },
    {
      "judul": "Rapat Evaluasi Bulanan",
      "tanggal": "20 Oktober 2025",
      "lokasi": "Balai Desa",
      "keterangan": "Membahas laporan kegiatan dan dokumentasi warga.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        title: const Text("Daftar Kegiatan"),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/kegiatan/tambah'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Cari kegiatan...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: (query) {
                // implement pencarian sederhana
                setState(() {
                  kegiatanList = kegiatanList
                      .where((item) => item["judul"]!
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                      .toList();
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: kegiatanList.isEmpty
                  ? const Center(child: Text("Belum ada kegiatan."))
                  : ListView.builder(
                      itemCount: kegiatanList.length,
                      itemBuilder: (context, index) {
                        final kegiatan = kegiatanList[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              kegiatan["judul"] ?? "-",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "${kegiatan["tanggal"]} • ${kegiatan["lokasi"]}",
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.info_outline),
                              color: AppTheme.primaryBlue,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => _DetailKegiatanDialog(
                                    kegiatan: kegiatan,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailKegiatanDialog extends StatelessWidget {
  final Map<String, String> kegiatan;

  const _DetailKegiatanDialog({required this.kegiatan});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Detail Kegiatan",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildField("Judul", kegiatan["judul"] ?? "-"),
            const SizedBox(height: 12),
            _buildField("Tanggal", kegiatan["tanggal"] ?? "-"),
            const SizedBox(height: 12),
            _buildField("Lokasi", kegiatan["lokasi"] ?? "-"),
            const SizedBox(height: 12),
            _buildField("Keterangan", kegiatan["keterangan"] ?? "-"),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    const Text("Tutup", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return TextFormField(
      readOnly: true,
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontWeight: FontWeight.w500),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}
