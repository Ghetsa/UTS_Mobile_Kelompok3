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

  // Variabel search dan filter
  String _searchQuery = '';
  String? _selectedStatusFilter;

  // Breakpoint untuk tampilan mobile / desktop
  static const double mobileBreakpoint = 600.0;

  // Variabel pagination
  int _currentPage = 0;
  final int _rowsPerPage = 10;

  // Data hasil filter
  List<Map<String, String>> _filteredAspirationData = [];

  @override
  void initState() {
    super.initState();
    _filterData();
  }

  // Fungsi memfilter data
  void _filterData({
    String? searchQuery,
    String? statusFilter,
  }) {
    setState(() {
      _searchQuery = searchQuery ?? _searchQuery;
      _selectedStatusFilter = statusFilter ?? _selectedStatusFilter;

      _filteredAspirationData = aspirationData.where((data) {
        // Filter judul
        bool matchesSearch = _searchQuery.isEmpty
            ? true
            : data['judul']!.toLowerCase().contains(_searchQuery.toLowerCase());

        // Filter status
        bool matchesStatus = _selectedStatusFilter == null ||
                _selectedStatusFilter == 'Semua' ||
                _selectedStatusFilter!.isEmpty
            ? true
            : data['status'] == _selectedStatusFilter;

        return matchesSearch && matchesStatus;
      }).toList();

      _currentPage = 0;
    });
  }

  // Fungsi mereset filter
  void _resetFilter() {
    setState(() {
      _searchQuery = '';
      _selectedStatusFilter = null;
      _filteredAspirationData = aspirationData;
      _currentPage = 0;
    });
  }

  // Fungsi menampilkan modal filter
  void _showFilterModal(BuildContext context) {
    final TextEditingController searchCtrl =
        TextEditingController(text: _searchQuery);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              backgroundColor: AppTheme.backgroundBlueWhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Text('Filter Pesan Warga',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppTheme.primaryBlue)),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Input field search judul
                    const Text(
                      "Judul",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppTheme.hitam,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: searchCtrl,
                      style: const TextStyle(
                        color: AppTheme.hitam,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: "Cari Judul",
                        hintStyle: const TextStyle(
                          color: AppTheme.abu,
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: AppTheme.abu.withOpacity(0.2),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppTheme.abu),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Dropdown filter status
                    const Text(
                      "Status",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppTheme.hitam,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.abu.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.abu),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedStatusFilter,
                        hint: const Text('-- Pilih Status --'),
                        items: const [
                          DropdownMenuItem(
                              value: 'Semua', child: Text('Semua')),
                          DropdownMenuItem(
                              value: 'Diterima', child: Text('Diterima')),
                          DropdownMenuItem(
                              value: 'Pending', child: Text('Pending')),
                          DropdownMenuItem(
                              value: 'Ditolak', child: Text('Ditolak')),
                        ],
                        onChanged: (val) =>
                            setModalState(() => _selectedStatusFilter = val),
                        dropdownColor: AppTheme.putih,
                        style: TextStyle(
                          color: AppTheme.hitam,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                // Tombol reset filter
                ElevatedButton(
                  onPressed: () {
                    _resetFilter();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.redMediumDark,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  child: const Text('Reset Filter',
                      style: TextStyle(color: Colors.white)),
                ),
                // Tombol terapkan filter
                ElevatedButton(
                  onPressed: () {
                    _filterData(
                      searchQuery: searchCtrl.text,
                      statusFilter: _selectedStatusFilter,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.greenDark,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  child: const Text('Terapkan',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Fungsi mendapatkan warna sesuai status aspirasi
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Diterima':
        return AppTheme.greenMedium;
      case 'Pending':
        return AppTheme.yellowMedium;
      case 'Ditolak':
        return AppTheme.redMedium;
      default:
        return AppTheme.abu;
    }
  }

  // Fungsi menampilkan bottom sheet menu aksi setiap aspirasi
  void _showPopupActionMenu(BuildContext context, Map<String, String> data) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Wrap(
          children: [
            // Menu Lihat Detail
            ListTile(
              leading: const Icon(Icons.info, color: AppTheme.blueMedium),
              title: const Text('Lihat Detail'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DetailAspirasi(data: data)));
              },
            ),
            // Menu Edit Aspirasi
            ListTile(
              leading: const Icon(Icons.edit, color: AppTheme.yellowMedium),
              title: const Text('Edit'),
              onTap: () async {
                Navigator.pop(context);
                final updatedData = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => EditAspirasi(data: data)));
                if (updatedData != null && mounted) {
                  setState(() {
                    final index = aspirationData.indexOf(data);
                    aspirationData[index] = updatedData;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Aspirasi berhasil diperbarui'),
                      backgroundColor: AppTheme.blueMedium,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
            ),
            // Menu Hapus Aspirasi
            ListTile(
              leading: const Icon(Icons.delete, color: AppTheme.redMedium),
              title: const Text('Hapus'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Konfirmasi Hapus'),
                    content: Text(
                        'Apakah kamu yakin ingin menghapus aspirasi "${data['judul']}"?'),
                    actions: [
                      TextButton(
                          child: const Text('Batal'),
                          onPressed: () => Navigator.pop(context)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.redMedium),
                        child: const Text('Hapus'),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() => aspirationData.remove(data));
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

  @override
  Widget build(BuildContext context) {
    // Cek apakah tampilan mobile atau desktop
    final isMobile = MediaQuery.of(context).size.width < mobileBreakpoint;

    // Pagination slicing
    final int startIndex = _currentPage * _rowsPerPage;
    final int endIndex =
        (_currentPage + 1) * _rowsPerPage > _filteredAspirationData.length
            ? _filteredAspirationData.length
            : (_currentPage + 1) * _rowsPerPage;
    final List<Map<String, String>> paginatedData =
        _filteredAspirationData.sublist(startIndex, endIndex);
    final int totalPages =
        (_filteredAspirationData.length / _rowsPerPage).ceil();

    return Scaffold(
      drawer: const AppSidebar(),
      backgroundColor: AppTheme.backgroundBlueWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        elevation: 3,
        title: const Text(
          'Semua Aspirasi',
          style:
              TextStyle(color: AppTheme.putihFull, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tombol filter di pojok kanan
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _showFilterModal(context),
                      icon: const Icon(Icons.filter_alt),
                      label: const Text("Filter Aspirasi"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.yellowDark,
                        foregroundColor: AppTheme.putihFull,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Jika tidak ada data hasil filter
                _filteredAspirationData.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Center(
                          child: Text(
                            "Tidak ada aspirasi yang sesuai.",
                            style: TextStyle(color: AppTheme.abu, fontSize: 16),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          // Tampilkan versi mobile atau desktop sesuai breakpoint
                          isMobile
                              ? _buildMobileList(paginatedData)
                              : _buildDesktopTable(paginatedData),
                          const SizedBox(height: 20),
                          // Kontrol pagination
                          _buildPaginationControls(totalPages),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan tombol pagination
  Widget _buildPaginationControls(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tombol previous
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed:
              _currentPage > 0 ? () => setState(() => _currentPage--) : null,
        ),
        // Tombol nomor halaman
        ...List.generate(totalPages, (i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _currentPage == i
                    ? AppTheme.primaryBlue
                    : AppTheme.putihFull,
                minimumSize: const Size(36, 36),
                padding: EdgeInsets.zero,
              ),
              onPressed: () => setState(() => _currentPage = i),
              child: Text('${i + 1}',
                  style: TextStyle(
                      color: _currentPage == i
                          ? AppTheme.putihFull
                          : AppTheme.hitam)),
            ),
          );
        }),
        // Tombol next
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _currentPage < totalPages - 1
              ? () => setState(() => _currentPage++)
              : null,
        ),
      ],
    );
  }

  // Widget untuk menampilkan tabel desktop
  Widget _buildDesktopTable(List<Map<String, String>> paginatedData) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor:
            MaterialStateProperty.all(AppTheme.lightBlue.withOpacity(0.3)),
        dataRowColor: MaterialStateProperty.all(AppTheme.backgroundBlueWhite),
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppTheme.hitam,
        ),
        columns: const [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('Judul')),
          DataColumn(label: Text('Pengirim')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Tanggal Dibuat')),
          DataColumn(label: Text('Aksi')),
        ],
        rows: paginatedData.map((data) {
          return DataRow(cells: [
            DataCell(Text(data['no']!)),
            DataCell(Text(data['judul']!)),
            DataCell(Text(data['pengirim']!)),
            DataCell(Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(data['status']!).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                data['status']!,
                style: TextStyle(
                  color: _getStatusColor(data['status']!),
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
            DataCell(Text(data['tanggalDibuat']!)),
            DataCell(Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onPressed: () => _showPopupActionMenu(context, data),
                ),
              ],
            )),
          ]);
        }).toList(),
      ),
    );
  }

  // Widget untuk menampilkan daftar aspirasi versi mobile
  Widget _buildMobileList(List<Map<String, String>> paginatedData) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: paginatedData.length,
      itemBuilder: (context, index) {
        final data = paginatedData[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppTheme.putihFull,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppTheme.abu,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            // Nomor urut dengan lingkaran biru
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryBlue,
              child: Text(
                data['no']!,
                style: const TextStyle(
                    color: AppTheme.putihFull, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              data['judul']!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Pengirim: ${data['pengirim']}',
                  style: const TextStyle(
                      color: AppTheme.hitam,
                      fontWeight: FontWeight.w500,
                      fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 14, color: AppTheme.abu),
                    const SizedBox(width: 4),
                    Text(
                      data['tanggalDibuat']!,
                      style: const TextStyle(color: AppTheme.abu, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showPopupActionMenu(context, data),
            ),
          ),
        );
      },
    );
  }
}
