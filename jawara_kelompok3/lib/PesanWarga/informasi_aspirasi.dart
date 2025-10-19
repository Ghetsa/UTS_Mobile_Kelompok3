import 'package:flutter/material.dart';
import '../../Layout/sidebar.dart';
import '../../Theme/app_theme.dart';
import 'detail_pesan.dart';
import 'edit_pesan.dart';

class SemuaAspirasi extends StatefulWidget {
  const SemuaAspirasi({super.key});

  @override
  State<SemuaAspirasi> createState() => _SemuaAspirasiState();
}

class _SemuaAspirasiState extends State<SemuaAspirasi> {
  // Data dummy
  List<Map<String, String>> aspirationData = [
    {
      'no': '1',
      'pengirim': 'Varizky Nahdiba Rinma',
      'judul': 'Titoobit',
      'status': 'Diterima',
      'tanggalDibuat': '16 Oktober 2025',
      'deskripsi':
          'Aspirasi mengenai peningkatan kualitas sistem informasi warga agar lebih mudah digunakan oleh masyarakat luas.',
    },
    {
      'no': '2',
      'pengirim': 'Habibie Ed Dien',
      'judul': 'Tes',
      'status': 'Pending',
      'tanggalDibuat': '28 September 2025',
      'deskripsi':
          'Saran terkait pengembangan fitur pelaporan online untuk warga yang ingin menyampaikan keluhan terkait fasilitas umum.',
    },
    {
      'no': '3',
      'pengirim': 'Rendy Setiawan',
      'judul': 'Perbaikan Jalan RT 05',
      'status': 'Ditolak',
      'tanggalDibuat': '15 Oktober 2025',
      'deskripsi':
          'Usulan perbaikan jalan rusak di wilayah RT 05 yang sering menyebabkan kecelakaan kecil pada malam hari.',
    },
    {
      'no': '4',
      'pengirim': 'Ani Lestari',
      'judul': 'Kegiatan Kesenian',
      'status': 'Pending',
      'tanggalDibuat': '14 Oktober 2025',
      'deskripsi':
          'Permohonan dukungan kegiatan kesenian tradisional untuk mempererat hubungan antar warga di lingkungan RW 02.',
    },
  ];

  // Variabel pencarian dan filter
  String _searchQuery = '';
  String? _selectedStatusFilter;

  final Color primaryColor = AppTheme.primaryBlue;
  final Color backgroundColor = AppTheme.backgroundBlueWhite;
  final Color inputBackground = AppTheme.lightBlue;

  final Color success = AppTheme.greenMedium;
  final Color warning = AppTheme.yellowMediumDark;
  final Color error = AppTheme.redMedium;

  // Getter untuk memfilter data berdasarkan pencarian dan status
  List<Map<String, String>> get _filteredAspirationData {
    return aspirationData.where((data) {
      if (_selectedStatusFilter != null &&
          _selectedStatusFilter!.isNotEmpty &&
          _selectedStatusFilter != 'Semua' &&
          data['status'] != _selectedStatusFilter) {
        return false;
      }

      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      return data.values.any((value) => value.toLowerCase().contains(query));
    }).toList();
  }

  // Mengatur warna status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Diterima':
        return success;
      case 'Pending':
        return warning;
      case 'Ditolak':
        return error;
      default:
        return Colors.grey;
    }
  }

  // Fungsi menghapus data
  void _deleteData(Map<String, String> data) {
    setState(() {
      aspirationData.remove(data);
    });
  }

  // Fungsi menampilkan popup aksi
  void _showPopupActionMenu(BuildContext context, Map<String, String> data) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            // Tombol detail aspirasi
            ListTile(
              leading: const Icon(Icons.info, color: Colors.blue),
              title: const Text('Lihat Detail'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailAspirasi(data: data),
                  ),
                );
              },
            ),

            // Tombol mengedit aspirasi
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.orange),
              title: const Text('Edit'),
              onTap: () async {
                Navigator.pop(context);
                final updatedData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditAspirasi(data: data),
                  ),
                );

                if (updatedData != null && mounted) {
                  setState(() {
                    final index = aspirationData.indexOf(data);
                    aspirationData[index] = updatedData;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Aspirasi berhasil diperbarui'),
                      backgroundColor: Colors.indigo.shade600,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),

            // Tombol menghapus aspirasi
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Hapus'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Konfirmasi Hapus'),
                    content: Text(
                      'Apakah kamu yakin ingin menghapus aspirasi "${data['judul']}"?',
                    ),
                    actions: [
                      // Tombol batal
                      TextButton(
                        child: const Text('Batal'),
                        onPressed: () => Navigator.pop(context),
                      ),

                      // Tombol hapus
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Hapus'),
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteData(data);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi menampilkan tampilan halaman
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: const AppSidebar(),
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Text(
          'Semua Aspirasi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari pengirim atau judul...',
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.blue.shade600,
                hintStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
            const SizedBox(height: 12),

            // Dropdown filter
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade600,
                borderRadius: BorderRadius.circular(14),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Colors.blue.shade700,
                  value: _selectedStatusFilter,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  isExpanded: true,
                  hint: const Text(
                    'Filter berdasarkan status',
                    style: TextStyle(color: Colors.white),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Semua', child: Text('Semua')),
                    DropdownMenuItem(
                        value: 'Diterima', child: Text('Diterima')),
                    DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'Ditolak', child: Text('Ditolak')),
                  ],
                  onChanged: (val) {
                    setState(() => _selectedStatusFilter = val);
                  },
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Card daftar aspirasi
            Expanded(
              child: _filteredAspirationData.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada data ditemukan',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredAspirationData.length,
                      itemBuilder: (context, index) {
                        final data = _filteredAspirationData[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: Colors.white,
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nomor urut
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blueAccent.shade700,
                                        Colors.lightBlueAccent.shade100
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Isi data
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Judul dan status
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              data['judul']!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(
                                                data['status']!,
                                              ).withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              data['status']!,
                                              style: TextStyle(
                                                color: _getStatusColor(
                                                    data['status']!),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),

                                      // Nama pengirim dan tanggal dibuat
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Pengirim: ${data['pengirim']}'),
                                          Text(
                                            data['tanggalDibuat']!,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(height: 20),

                                      // Tombol menu aksi
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.more_vert),
                                            onPressed: () =>
                                                _showPopupActionMenu(
                                                    context, data),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
