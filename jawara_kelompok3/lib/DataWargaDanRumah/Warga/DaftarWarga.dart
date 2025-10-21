import 'package:flutter/material.dart';
import '../../Theme/app_theme.dart';
import '../../Layout/sidebar.dart';

class DaftarWargaPage extends StatelessWidget {
  const DaftarWargaPage({super.key});

  final List<Map<String, dynamic>> warga = const [
    {
      "nama": "Ghetsa Ramadhani",
      "nik": "137111011030005",
      "keluarga": "Keluarga Ghetsa Ramadhani",
      "jenisKelamin": "Perempuan",
      "statusDomisili": "Aktif",
      "statusHidup": "Hidup",
    },
    {
      "nama": "Muhammad Gunawan",
      "nik": "357100715000912",
      "keluarga": "Keluarga Gunawan",
      "jenisKelamin": "Laki-laki",
      "statusDomisili": "Aktif",
      "statusHidup": "Wafat",
    },
    {
      "nama": "Muhammad Syahrul",
      "nik": "357100715000912",
      "keluarga": "Keluarga Gunawan",
      "jenisKelamin": "Laki-laki",
      "statusDomisili": "Aktif",
      "statusHidup": "Hidup",
    },
    {
      "nama": "Oltha Rosyeda",
      "nik": "357100715000546",
      "keluarga": "Keluarga Alhaq",
      "jenisKelamin": "Perempuan",
      "statusDomisili": "Aktif",
      "statusHidup": "Hidup",
    },
    {
      "nama": "Lutfhi Triang",
      "nik": "357100715000235",
      "keluarga": "Keluarga Luthfi",
      "jenisKelamin": "Laki-laki",
      "statusDomisili": "Aktif",
      "statusHidup": "Hidup",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlueWhite,
      appBar: AppBar(
        title: const Text("Daftar Warga"),
        backgroundColor: AppTheme.primaryBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            tooltip: "Filter Data",
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Filter Data Warga"),
                  content: const Text("Fitur filter akan ditambahkan di sini."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Tutup"),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Tombol Tambah dan Cetak
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.add, color: AppTheme.greenSuperDark),
                  label: Text(
                    "Tambah Warga",
                    style: TextStyle(
                      color: AppTheme.greenSuperDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: AppTheme.greenExtraLight,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.picture_as_pdf, color: AppTheme.redDark),
                  label: Text(
                    "Cetak PDF",
                    style: TextStyle(
                      color: AppTheme.redDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: AppTheme.redExtraLight,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),

            /// Daftar warga (Card)
            Expanded(
              child: ListView.builder(
                itemCount: warga.length,
                itemBuilder: (context, index) {
                  final item = warga[index];
                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: AppTheme.grayLight,
                        width: 1.5,
                      ),
                    ),
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25, right: 16, top: 16, bottom: 16),
                      // padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // CircleAvatar(
                          //   backgroundColor: AppTheme.primaryBlue,
                          //   child: Text(
                          //     "${index + 1}",
                          //     style: const TextStyle(
                          //         color: Colors.white, fontSize: 16),
                          //   ),
                          // ),
                          // const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['nama'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(item['nik'],
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[700])),
                                Text(item['keluarga'],
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[700])),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildStatusChip(item['statusDomisili']),
                                    const SizedBox(width: 6),
                                    _buildStatusChip(item['statusHidup']),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert,
                                color: AppTheme.primaryBlue),
                            onSelected: (value) {
                              if (value == 'detail') {
                                debugPrint("Detail: ${item["nama"]}");
                              } else if (value == 'edit') {
                                debugPrint("Edit: ${item["nama"]}");
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'detail',
                                child: Text('Detail'),
                              ),
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                            ],
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

  /// 🔹 Chip status menggunakan warna AppTheme
  Widget _buildStatusChip(String status) {
    final bool isActive =
        status.toLowerCase() == "aktif" || status.toLowerCase() == "hidup";
    final Color bgColor =
        isActive ? AppTheme.greenExtraLight : AppTheme.redExtraLight;
    final Color textColor =
        isActive ? AppTheme.greenSuperDark : AppTheme.redDark;
    final Color borderColor = isActive ? AppTheme.greenDark : AppTheme.redDark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
