import 'package:flutter/material.dart';
import '../../Layout/sidebar.dart' as layout_sidebar;
import 'detail_pengguna.dart';
import '../../main.dart';

const Color primaryDark = Color(0xFF5C4E43);
const Color secondaryCream = Color(0xFFEDE8D2);
const Color accentGold = Color(0xFFC7B68D);

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

  User(
    this.no,
    this.nama,
    this.email,
    this.statusRegistrasi, {
    this.role = "Warga",
    this.nik = "Tidak Tersedia",
    this.noHp = "08XXXXXXXXXX",
    this.jenisKelamin = "Tidak Tersedia",
  });
}

class DaftarPenggunaPage extends StatelessWidget {
  const DaftarPenggunaPage({super.key});

  static final List<User> _userData = [
    User(
      1,
      "Bila",
      "bila@gmail.com",
      "Diterima",
      role: "Bendahara",
      noHp: "089723212412",
      nik: "3273xxxxxxxxxxxx",
      jenisKelamin: "Perempuan",
    ),
    User(2, "Ijat 4", "ijat4@gmail.com", "Diterima"),
    User(3, "Ijat 3", "ijat3@gmail.com", "Diterima"),
    User(4, "Ijat 2", "ijat2@gmail.com", "Diterima"),
    User(5, "Ijat 1", "ijat1@gmail.com", "Diterima"),
    User(6, "Afifah Khorunnisa", "afifah@gmail.com", "Diterima"),
    User(7, "Raudhif Firdaus Naufal", "raudhif@gmail.com", "Diterima"),
    User(8, "ASDOPAR", "asdopar@gmail.com", "Diterima"),
    User(9, "FAJRUL", "fajrul@gmail.com", "Diterima"),
    User(10, "Mara Nunez", "mara@mailinator.com", "Diterima"),
    User(11, "Habibie Ed Dien", "habibie.tk@gmail.com", "Diterima"),
    User(12, "Admin Jawara", "admin1@mailinator.com", "Diterima"),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daftar Pengguna",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      drawer: const layout_sidebar.AppSidebar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),

                // Card yang membungkus tabel data
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Responsive Data Table
                        SizedBox(
                          width: double.infinity,
                          child: _buildDataTable(context, isDesktop),
                        ),
                        const Divider(height: 30, thickness: 1),
                        _buildPagination(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // FUNGSI DIALOG FILTER
  void _showFilterDialog(BuildContext context) {
    final List<String> statusOptions = [
      'Semua',
      'Diterima',
      'Menunggu Persetujuan',
      'Ditolak',
    ];
    String? selectedStatus;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul dan tombol close
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Filter Manajemen Pengguna",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Input Nama
                  const Text(
                    "Nama",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Cari nama...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: primaryDark,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Dropdown Status
                  const Text(
                    "Status",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    hint: const Text("-- Pilih Status --"),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    items: statusOptions.map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      selectedStatus = newValue;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Tombol Aksi (Reset dan Terapkan)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tombol Reset Filter
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Filter di-reset!')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryDark,
                          side: BorderSide(color: primaryDark.withOpacity(0.5)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: const Text("Reset Filter"),
                      ),

                      // Tombol Terapkan
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Filter berhasil diterapkan!'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryDark,
                          foregroundColor: secondaryCream,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text("Terapkan"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget untuk Header (Tombol Tambah Pengguna dan Filter)
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            _showFilterDialog(context);
          },
          icon: const Icon(Icons.filter_list),
          color: secondaryCream,
          style: IconButton.styleFrom(
            backgroundColor: primaryDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          tooltip: 'Filter Data',
        ),
      ],
    );
  }

  // Widget untuk Tabel Data Pengguna
  Widget _buildDataTable(BuildContext context, bool isDesktop) {
    if (isDesktop) {
      return DataTable(
        columnSpacing: 30,
        dataRowMaxHeight: 50,
        headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
        columns: const [
          DataColumn(
            label: Text('NO', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text('NAMA', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text('EMAIL', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text(
              'STATUS REGISTRASI',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text('AKSI', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
        // Di sini 'context' sekarang tersedia
        rows: _userData.map((user) => _buildDataRow(context, user)).toList(),
      );
    } else {
      // Tampilan sederhana untuk
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 30,
          dataRowMaxHeight: 50,
          headingRowColor: MaterialStateProperty.all(Colors.grey[50]),
          columns: const [
            DataColumn(
              label: Text('NO', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text(
                'NAMA',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'EMAIL',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'STATUS REGISTRASI',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'AKSI',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          // Di sini 'context' sekarang tersedia
          rows: _userData.map((user) => _buildDataRow(context, user)).toList(),
        ),
      );
    }
  }

  // Baris Data untuk Tabel
  DataRow _buildDataRow(BuildContext context, User user) {
    return DataRow(
      cells: [
        DataCell(Text(user.no.toString())),
        DataCell(Text(user.nama)),
        DataCell(Text(user.email)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              user.statusRegistrasi,
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        DataCell(
          // Tombol Aksi (Tiga Titik Vertikal)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onSelected: (String result) {
              // Handler Aksi
              if (result == 'detail') {
                // Navigasi ke Halaman Detail Pengguna
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPenggunaPage(user: user),
                  ),
                );
              } else if (result == 'edit') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Aksi Edit untuk ${user.nama} telah dipilih.',
                    ),
                  ),
                );
              } else if (result == 'hapus') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Aksi Hapus untuk ${user.nama} telah dipilih.',
                    ),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'detail',
                child: Text('Detail'),
              ),
              const PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
              const PopupMenuItem<String>(value: 'hapus', child: Text('Hapus')),
            ],
          ),
        ),
      ],
    );
  }

  // Widget untuk Paginasi
  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPaginationButton(
          icon: Icons.keyboard_arrow_left,
          onPressed: () {},
          isActive: false,
        ),
        const SizedBox(width: 8),
        _buildPaginationButton(label: '1', onPressed: () {}, isActive: true),
        const SizedBox(width: 8),
        _buildPaginationButton(label: '2', onPressed: () {}, isActive: false),
        const SizedBox(width: 8),
        _buildPaginationButton(
          icon: Icons.keyboard_arrow_right,
          onPressed: () {},
          isActive: true,
        ),
      ],
    );
  }

  // Helper untuk Tombol Paginasi
  Widget _buildPaginationButton({
    String? label,
    IconData? icon,
    required VoidCallback onPressed,
    required bool isActive,
  }) {
    final color = isActive ? primaryDark : Colors.grey;
    final textColor = isActive ? primaryDark : Colors.black87;

    return Container(
      decoration: BoxDecoration(
        color: isActive ? primaryDark.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isActive ? primaryDark : Colors.grey[300]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isActive ? onPressed : null,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: label != null
                ? Text(
                    label,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  )
                : Icon(icon, size: 20, color: color),
          ),
        ),
      ),
    );
  }
}
