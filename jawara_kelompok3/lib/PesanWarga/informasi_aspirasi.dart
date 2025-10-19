import 'package:flutter/material.dart';
// Menggunakan path sidebar Anda (Asumsi digunakan untuk wrapping layout/drawer)
import '../../Layout/sidebar.dart'; 
// Menggunakan path theme Anda (Asumsi menyediakan warna kustom)
import '../../Theme/app_theme.dart';

// --- PLACEHOLDER UNTUK SIMULASI app_theme.dart ---
// Anda harus mengganti kelas ini dengan import AppTheme yang sebenarnya.
class AppTheme {
  // Warna kustom berdasarkan file React sebelumnya
  static const Color primaryBlue = Color(0xFF3b82f6); // Header, Filter, Pagination
  static const Color primaryGreen = Color(0xFF10b981); // Status 'Diterima'
  static const Color lightBlue = Color(0xFFbfdbfe); // Header Tabel
  static const Color yellow = Color(0xFFFACC15); // Status 'Pending'
  static const Color red = Color(0xFFEF4444); // Status 'Ditolak'
}
// --- AKHIR PLACEHOLDER ---

class SemuaAspirasi extends StatefulWidget {
  const SemuaAspirasi({super.key});

  @override
  State<SemuaAspirasi> createState() => _SemuaAspirasiState();
}

class _SemuaAspirasiState extends State<SemuaAspirasi> {
  // Data dummy aspirasi
  final List<Map<String, String>> initialAspirationData = const [
    { 'no': '1', 'pengirim': 'varizky nahdiba rinma', 'judul': 'titoobit', 'status': 'Diterima', 'tanggalDibuat': '16 Oktober 2025' },
    { 'no': '2', 'pengirim': 'Habibie Ed Dien', 'judul': 'tes', 'status': 'Pending', 'tanggalDibuat': '28 September 2025' },
    { 'no': '3', 'pengirim': 'Rendy Setiawan', 'judul': 'Permintaan Perbaikan Jalan Berlubang di RT 05', 'status': 'Ditolak', 'tanggalDibuat': '15 Oktober 2025' },
    { 'no': '4', 'pengirim': 'Ani Lestari', 'judul': 'Usulan Kegiatan Kesenian untuk Malam Kemerdekaan', 'status': 'Pending', 'tanggalDibuat': '14 Oktober 2025' },
    { 'no': '5', 'pengirim': 'Budi Santoso', 'judul': 'Inisiatif Pengadaan Tempat Sampah Organik', 'status': 'Diterima', 'tanggalDibuat': '13 Oktober 2025' },
    { 'no': '6', 'pengirim': 'Citra Kirana', 'judul': 'Keluhan tentang Drainase yang Tersumbat', 'status': 'Pending', 'tanggalDibuat': '12 Oktober 2025' },
    { 'no': '7', 'pengirim': 'Dewi Ayu', 'judul': 'Saran Peningkatan Keamanan Lingkungan', 'status': 'Diterima', 'tanggalDibuat': '11 Oktober 2025' },
    { 'no': '8', 'pengirim': 'Eko Prasetyo', 'judul': 'Permintaan Jadwal Ronda Malam yang Lebih Fleksibel', 'status': 'Pending', 'tanggalDibuat': '10 Oktober 2025' },
    { 'no': '9', 'pengirim': 'Fahri Husain', 'judul': 'Aspirasi untuk Penambahan Lampu Penerangan Jalan', 'status': 'Ditolak', 'tanggalDibuat': '09 Oktober 2025' },
    { 'no': '10', 'pengirim': 'Gita Wulandari', 'judul': 'Evaluasi Program Kebersihan Lingkungan', 'status': 'Diterima', 'tanggalDibuat': '08 Oktober 2025' },
  ];

  String _searchQuery = '';
  String? _selectedStatusFilter;

  List<Map<String, String>> get _filteredAspirationData {
    return initialAspirationData.where((data) {
      // Filter Status
      if (_selectedStatusFilter != null && _selectedStatusFilter!.isNotEmpty && data['status'] != _selectedStatusFilter) {
        return false;
      }

      // Filter Pencarian
      if (_searchQuery.isEmpty) {
        return true;
      }
      final query = _searchQuery.toLowerCase();
      return data.values.any((value) => value.toLowerCase().contains(query));
    }).toList();
  }

  // --- WIDGET HELPER ---

  Widget _getStatusBadge(String status) {
    Color textColor;
    Color bgColor;

    switch (status) {
      case 'Diterima':
        textColor = AppTheme.primaryGreen;
        bgColor = AppTheme.primaryGreen.withOpacity(0.1);
        break;
      case 'Pending':
        textColor = const Color(0xFFB45309); // Near yellow-800
        bgColor = AppTheme.yellow.withOpacity(0.2);
        break;
      case 'Ditolak':
        textColor = const Color(0xFFB91C1C); // Near red-800
        bgColor = AppTheme.red.withOpacity(0.2);
        break;
      default:
        textColor = Colors.grey.shade800;
        bgColor = Colors.grey.shade100;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    final statusOptions = initialAspirationData.map((e) => e['status']!).toSet().toList();
    String? tempSelectedStatus = _selectedStatusFilter;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Filter Aspirasi', style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filter berdasarkan Status:', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: tempSelectedStatus,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    hint: const Text('Semua Status'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Semua Status')),
                      ...statusOptions.map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      )),
                    ],
                    onChanged: (value) {
                      setStateModal(() {
                        tempSelectedStatus = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedStatusFilter = tempSelectedStatus;
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Terapkan Filter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildAspirationTable(double screenWidth) {
    // Tampilan Tabel untuk layar lebar (desktop/tablet)
    if (_filteredAspirationData.isEmpty) {
      return _buildEmptyState();
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: DataTable(
          columnSpacing: 16,
          horizontalMargin: 16,
          dataRowHeight: 60,
          headingRowColor: MaterialStateProperty.resolveWith((states) => AppTheme.lightBlue.withOpacity(0.5)),
          columns: const [
            DataColumn(label: Text('NO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
            DataColumn(label: Text('PENGIRIM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
            DataColumn(label: Text('JUDUL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
            DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
            DataColumn(label: Text('TANGGAL DIBUAT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
            DataColumn(label: Text('AKSI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey))),
          ],
          rows: _filteredAspirationData.map((data) {
            return DataRow(
              cells: [
                DataCell(Text(data['no']!)),
                DataCell(Text(data['pengirim']!, style: const TextStyle(fontWeight: FontWeight.w500))),
                DataCell(Text(data['judul']!, maxLines: 2, overflow: TextOverflow.ellipsis)),
                DataCell(_getStatusBadge(data['status']!)),
                DataCell(Text(data['tanggalDibuat']!, style: const TextStyle(color: Colors.grey))),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
                    onPressed: () {
                      // Logika aksi detail/edit/hapus
                      print('Aksi untuk Aspirasi ${data['no']}');
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAspirationCardList() {
    // Tampilan Card List untuk layar sempit (mobile)
    if (_filteredAspirationData.isEmpty) {
      return _buildEmptyState();
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredAspirationData.length,
      itemBuilder: (context, index) {
        final data = _filteredAspirationData[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${data['no']!}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                    Row(
                      children: [
                        _getStatusBadge(data['status']!),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
                          onPressed: () {
                            print('Aksi untuk Aspirasi ${data['no']}');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Pengirim: ${data['pengirim']!}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.primaryBlue),
                ),
                const SizedBox(height: 4),
                Text(
                  data['judul']!,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Tanggal Dibuat: ${data['tanggalDibuat']!}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        margin: const EdgeInsets.only(top: 24),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, style: BorderStyle.solid),
        ),
        child: const Text(
          'Tidak ditemukan aspirasi yang sesuai dengan kriteria filter/pencarian.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Menggunakan LayoutBuilder untuk mendeteksi lebar layar (Responsif)
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;

        return Scaffold(
          backgroundColor: Colors.grey.shade100, // Warna latar belakang halaman
          // AppBar mengikuti desain header biru pada contoh React/gambar
          appBar: AppBar(
            backgroundColor: AppTheme.primaryBlue,
            title: const Text(
              'Semua Aspirasi',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          
          // Drawer akan menggunakan `Sidebar` jika ini adalah implementasi nyata
          // drawer: const Sidebar(), // Menggunakan import Sidebar
          
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200), // Batasan lebar konten
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bagian Pencarian dan Filter
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search Bar (Ambil 3/4 lebar)
                        Expanded(
                          flex: isMobile ? 1 : 3,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Cari Pengirim atau Judul Aspirasi...',
                              prefixIcon: const Icon(Icons.search, color: Colors.grey),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        setState(() {
                                          _searchQuery = '';
                                        });
                                        FocusScope.of(context).unfocus();
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Tombol Filter (Ambil 1/4 lebar)
                        Expanded(
                          flex: isMobile ? 0 : 1, // Di mobile tidak perlu expanded jika hanya tombol
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Chip Filter (Hanya terlihat di layar lebar)
                                if (!isMobile && _selectedStatusFilter != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.lightBlue,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(_selectedStatusFilter!, style: const TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.w500)),
                                        const SizedBox(width: 4),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedStatusFilter = null;
                                            });
                                          },
                                          child: const Icon(Icons.close, size: 16, color: AppTheme.primaryBlue),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (!isMobile && _selectedStatusFilter != null)
                                  const SizedBox(width: 8),

                                // Tombol Filter Ikon
                                SizedBox(
                                  height: 55, // Sesuaikan dengan tinggi TextFormField
                                  child: ElevatedButton(
                                    onPressed: () => _showFilterModal(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryBlue,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      padding: const EdgeInsets.all(12),
                                      minimumSize: const Size(55, 0),
                                    ),
                                    child: const Icon(Icons.filter_alt, color: Colors.white, size: 24),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),

                    // Widget Konten Utama: Tabel (Desktop/Tablet) vs Card List (Mobile)
                    isMobile
                        ? _buildAspirationCardList()
                        : _buildAspirationTable(constraints.maxWidth),
                    
                    // Paginasi Simulasi (Hanya ditampilkan jika tidak ada filter/pencarian aktif)
                    if (_searchQuery.isEmpty && _selectedStatusFilter == null && initialAspirationData.length > 10)
                      _buildPagination(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chevron_left, color: Colors.grey),
              tooltip: 'Sebelumnya',
            ),
            ...['1', '2', '...', '13'].map((page) {
              final isCurrent = page == '1';
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isCurrent ? AppTheme.primaryBlue : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: isCurrent ? null : Border.all(color: Colors.grey.shade300),
                  ),
                  child: page == '...'
                      ? const Text('...', style: TextStyle(color: Colors.grey))
                      : Text(
                          page,
                          style: TextStyle(
                            color: isCurrent ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                ),
              );
            }).toList(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chevron_right, color: Colors.grey),
              tooltip: 'Berikutnya',
            ),
          ],
        ),
      ),
    );
  }
}
