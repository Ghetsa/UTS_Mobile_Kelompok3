import 'package:flutter/material.dart';
import '../../Theme/app_theme.dart';
import '../../Layout/sidebar.dart';

class DaftarWargaPage extends StatelessWidget {
  const DaftarWargaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> dataWarga = [
      {
        "no": "1",
        "nama": "Budi Santoso",
        "alamat": "Jl. Melati No. 12",
        "telepon": "0812-1111-2222",
        "statusDomisili": "Aktif",
        "statusHidup": "Hidup",
      },
      {
        "no": "2",
        "nama": "Siti Aminah",
        "alamat": "Jl. Mawar No. 5",
        "telepon": "0813-2222-3333",
        "statusDomisili": "Aktif",
        "statusHidup": "Hidup",
      },
      {
        "no": "3",
        "nama": "Andi Wijaya",
        "alamat": "Jl. Kenanga No. 9",
        "telepon": "0814-3333-4444",
        "statusDomisili": "Aktif",
        "statusHidup": "Hidup",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Warga"),
        backgroundColor: AppTheme.primaryBlue,
      ),
      drawer: const AppSidebar(),
      backgroundColor: AppTheme.backgroundBlueWhite,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ✅ Baris tombol atas (Filter & Tambah Warga di kanan)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Tombol Filter
                ElevatedButton.icon(
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
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  label: const Text("Filter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.purpleDeep,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// ✅ Tabel Data Warga
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: constraints.maxWidth),
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                              AppTheme.lightBlue.withOpacity(0.3)),
                          dataRowColor: WidgetStateProperty.all(Colors.white),
                          columns: const [
                            DataColumn(
                              label: Text("No",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryBlue)),
                            ),
                            DataColumn(
                              label: Text("Nama Warga",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryBlue)),
                            ),
                            DataColumn(
                              label: Text("Alamat",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryBlue)),
                            ),
                            DataColumn(
                              label: Text("No Telepon",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryBlue)),
                            ),
                            DataColumn(
                              label: Text("Status Domisili",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryBlue)),
                            ),
                            DataColumn(
                              label: Text("Status Hidup",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryBlue)),
                            ),
                            DataColumn(
                              label: Text("Aksi",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryBlue)),
                            ),
                          ],
                          rows: dataWarga.map((row) {
                            return DataRow(
                              cells: [
                                DataCell(Text(row["no"]!)),
                                DataCell(Text(row["nama"]!)),
                                DataCell(Text(row["alamat"]!)),
                                DataCell(Text(row["telepon"]!)),
                                DataCell(
                                    _buildStatusChip(row["statusDomisili"]!)),
                                DataCell(_buildStatusChip(row["statusHidup"]!)),
                                DataCell(
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert,
                                        color: AppTheme.primaryBlue),
                                    onSelected: (value) {
                                      if (value == 'detail') {
                                        debugPrint("Detail: ${row["nama"]}");
                                      } else if (value == 'edit') {
                                        debugPrint("Edit: ${row["nama"]}");
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'detail',
                                        child: Text('Detail'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
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

  /// ✅ Badge status (Aktif / Hidup)
  Widget _buildStatusChip(String status) {
    final bool isActive =
        status.toLowerCase() == "aktif" || status.toLowerCase() == "hidup";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isActive ? Colors.green[800] : Colors.red[800],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
