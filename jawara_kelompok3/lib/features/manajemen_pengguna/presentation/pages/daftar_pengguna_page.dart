import 'package:flutter/material.dart';
import '../../../../core/layout/sidebar.dart' as layout_sidebar;
import 'detail_pengguna_page.dart';
import 'edit_pengguna_page.dart';
import '../../../../core/theme/app_theme.dart';

// Model pengguna
class User {
  final int no;
  final String nama;
  final String email;
  final String statusRegistrasi;
  final String role;
  final String nik;
  final String noHp;
  final String jenisKelamin;
  final String? fotoIdentitas;

  User(
    this.no,
    this.nama,
    this.email,
    this.statusRegistrasi,
    this.role,
    this.nik,
    this.noHp,
    this.jenisKelamin,
    this.fotoIdentitas,
  );
}

class DaftarPenggunaPage extends StatefulWidget {
  const DaftarPenggunaPage({super.key});

  @override
  State<DaftarPenggunaPage> createState() => _DaftarPenggunaPageState();
}

class _DaftarPenggunaPageState extends State<DaftarPenggunaPage> {
  // Data dummy pengguna
  List<User> _userData = [
    User(
      1,
      "Bila",
      "bila@gmail.com",
      "Diterima",
      "Bendahara",
      "3273012345678901",
      "089723212412",
      "Perempuan",
      "assets/images/gambar1.jpg",
    ),
    User(
      2,
      "Ijat 4",
      "ijat4@gmail.com",
      "Diterima",
      "Warga",
      "3273012345678902",
      "081234567890",
      "Laki-laki",
      "assets/images/gambar1.jpg",
    ),
    User(
      3,
      "Ijat 3",
      "ijat3@gmail.com",
      "Diterima",
      "Warga",
      "3273012345678903",
      "081234567891",
      "Laki-laki",
      "assets/images/gambar1.jpg",
    ),
    User(
      4,
      "Ijat 2",
      "ijat2@gmail.com",
      "Diterima",
      "Warga",
      "3273012345678904",
      "081234567892",
      "Laki-laki",
      "assets/images/gambar1.jpg",
    ),
    User(
      5,
      "Ijat 1",
      "ijat1@gmail.com",
      "Diterima",
      "Warga",
      "3273012345678905",
      "081234567893",
      "Laki-laki",
      "assets/images/gambar1.jpg",
    ),
    User(
      6,
      "Afifah Khorunnisa",
      "afifah@gmail.com",
      "Diterima",
      "Warga",
      "3273012345678906",
      "081234567894",
      "Perempuan",
      "assets/images/gambar1.jpg",
    ),
    User(
      7,
      "Raudhif Firdaus Naufal",
      "raudhif@gmail.com",
      "Diterima",
      "Warga",
      "3273012345678907",
      "081234567895",
      "Laki-laki",
      "assets/images/gambar1.jpg",
    ),
    User(
      8,
      "ASDOPAR",
      "asdopar@gmail.com",
      "Diterima",
      "Warga",
      "3273012345678908",
      "081234567896",
      "Laki-laki",
      "assets/images/gambar1.jpg",
    ),
    User(
      9,
      "FAJRUL",
      "fajrul@gmail.com",
      "Diterima",
      "Warga",
      "3273012345678909",
      "081234567897",
      "Laki-laki",
      "assets/images/gambar1.jpg",
    ),
    User(
      10,
      "Mara Nunez",
      "mara@mailinator.com",
      "Diterima",
      "Warga",
      "3273012345678910",
      "081234567898",
      "Perempuan",
      "assets/images/gambar1.jpg",
    ),
  ];

  // Filter & search
  String _searchQuery = '';
  String? _selectedStatusFilter;

  // Pagination
  int _currentPage = 0;
  final int _rowsPerPage = 10;

  // Mobile breakpoint
  static const double mobileBreakpoint = 600.0;

  List<User> _filteredUserData = [];

  @override
  void initState() {
    super.initState();
    _filterData();
  }

  // Fungsi filter data
  void _filterData({String? searchQuery, String? statusFilter}) {
    setState(() {
      _searchQuery = searchQuery ?? _searchQuery;
      _selectedStatusFilter = statusFilter ?? _selectedStatusFilter;

      _filteredUserData = _userData.where((user) {
        final matchesSearch = _searchQuery.isEmpty
            ? true
            : user.nama.toLowerCase().contains(_searchQuery.toLowerCase());

        final matchesStatus = _selectedStatusFilter == null ||
                _selectedStatusFilter == 'Semua' ||
                _selectedStatusFilter!.isEmpty
            ? true
            : user.statusRegistrasi == _selectedStatusFilter;

        return matchesSearch && matchesStatus;
      }).toList();

      _currentPage = 0;
    });
  }

  // Reset filter
  void _resetFilter() {
    setState(() {
      _searchQuery = '';
      _selectedStatusFilter = null;
      _filteredUserData = _userData;
      _currentPage = 0;
    });
  }

  // Show modal filter
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
              title: const Text('Filter Pengguna',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue)),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Nama",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: searchCtrl,
                      style: TextStyle(
                        color: AppTheme.hitam,
                      ),
                      decoration: InputDecoration(
                        hintText: "Cari nama",
                        hintStyle: TextStyle(
                          color: AppTheme.abu,
                        ),
                        filled: true,
                        fillColor: AppTheme.abu.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppTheme.abu,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppTheme.abu,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppTheme.primaryBlue,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text("Status",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.abu.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.abu),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedStatusFilter,
                          hint: const Text(
                            '-- Pilih Status --',
                            style: TextStyle(color: AppTheme.abu),
                          ),
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
                          dropdownColor: AppTheme.putihFull,
                          style: const TextStyle(color: AppTheme.hitam),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
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
                      style: TextStyle(color: AppTheme.putihFull)),
                ),
                ElevatedButton(
                  onPressed: () {
                    _filterData(
                        searchQuery: searchCtrl.text,
                        statusFilter: _selectedStatusFilter);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.greenDark,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  child: const Text('Terapkan',
                      style: TextStyle(color: AppTheme.putihFull)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Warna status pengguna
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Diterima':
        return AppTheme.greenMediumDark;
      case 'Menunggu Persetujuan':
        return AppTheme.yellowMediumDark;
      case 'Ditolak':
        return AppTheme.redMedium;
      default:
        return AppTheme.abu;
    }
  }

  // Bottom sheet menu aksi
  void _showActionMenu(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.info, color: AppTheme.blueMedium),
              title: const Text('Lihat Detail'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DetailPenggunaPage(user: user)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit, color: AppTheme.yellowMedium),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => EditPenggunaPage(user: user)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppTheme.redMedium),
              title: const Text('Hapus'),
              onTap: () {
                Navigator.pop(context);
                // Konfirmasi sebelum menghapus
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Konfirmasi'),
                      content: Text(
                          'Apakah Anda yakin ingin menghapus pengguna "${user.nama}"?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Batal',
                            style: TextStyle(color: AppTheme.hitam),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.redMedium,
                          ),
                          onPressed: () {
                            setState(() => _userData.remove(user));
                            _filterData();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Hapus',
                            style: TextStyle(color: AppTheme.putihFull),
                          ),
                        ),
                      ],
                    );
                  },
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
    final isMobile = MediaQuery.of(context).size.width < mobileBreakpoint;

    // Pagination slicing
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex =
        (_currentPage + 1) * _rowsPerPage > _filteredUserData.length
            ? _filteredUserData.length
            : (_currentPage + 1) * _rowsPerPage;
    final paginatedData = _filteredUserData.sublist(startIndex, endIndex);
    final totalPages = (_filteredUserData.length / _rowsPerPage).ceil();

    // UI utama
    return Scaffold(
      drawer: const layout_sidebar.AppSidebar(),
      backgroundColor: AppTheme.backgroundBlueWhite,
      appBar: AppBar(
        title: const Text('Daftar Pengguna',
            style: TextStyle(
                color: AppTheme.putihFull, fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryBlue,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tombol filter
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _showFilterModal(context),
                      icon: const Icon(Icons.filter_alt),
                      label: const Text("Filter Pengguna"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.yellowDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 25),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _filteredUserData.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: Text('Tidak ada pengguna yang sesuai.',
                              style: TextStyle(color: AppTheme.abu)),
                        ),
                      )
                    : Column(
                        children: [
                          isMobile
                              ? _buildMobileList(paginatedData)
                              : _buildDesktopTable(paginatedData),
                          const SizedBox(height: 20),
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

  Widget _buildDesktopTable(List<User> paginatedData) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor:
            MaterialStateProperty.all(AppTheme.lightBlue.withOpacity(0.3)),
        dataRowColor: MaterialStateProperty.all(AppTheme.backgroundBlueWhite),
        columns: const [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('Nama')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Status Registrasi')),
          DataColumn(label: Text('Aksi')),
        ],
        rows: paginatedData.map((user) {
          return DataRow(cells: [
            DataCell(Text(user.no.toString())),
            DataCell(Text(user.nama)),
            DataCell(Text(user.email)),
            DataCell(Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(user.statusRegistrasi).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                user.statusRegistrasi,
                style: TextStyle(
                    color: _getStatusColor(user.statusRegistrasi),
                    fontWeight: FontWeight.bold),
              ),
            )),
            DataCell(IconButton(
              icon: const Icon(Icons.more_vert, size: 20),
              onPressed: () => _showActionMenu(context, user),
            )),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildMobileList(List<User> paginatedData) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: paginatedData.length,
      itemBuilder: (context, index) {
        final user = paginatedData[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppTheme.putihFull,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: AppTheme.abu,
                  blurRadius: 6,
                  offset: const Offset(0, 3))
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryBlue,
              child: Text(user.no.toString(),
                  style: const TextStyle(
                      color: AppTheme.putihFull, fontWeight: FontWeight.bold)),
            ),
            title: Text(user.nama,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(user.email,
                    style: const TextStyle(
                        color: AppTheme.blueMediumLight, fontSize: 12)),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getStatusColor(user.statusRegistrasi)
                        .withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(user.statusRegistrasi,
                      style: TextStyle(
                          color: _getStatusColor(user.statusRegistrasi),
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showActionMenu(context, user),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaginationControls(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed:
              _currentPage > 0 ? () => setState(() => _currentPage--) : null,
        ),
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
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _currentPage < totalPages - 1
              ? () => setState(() => _currentPage++)
              : null,
        ),
      ],
    );
  }
}
