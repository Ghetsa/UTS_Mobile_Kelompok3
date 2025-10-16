import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../layout/sidebar.dart';

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
      },
      {
        "no": "2",
        "nama": "Siti Aminah",
        "alamat": "Jl. Mawar No. 5",
        "telepon": "0813-2222-3333",
      },
      {
        "no": "3",
        "nama": "Andi Wijaya",
        "alamat": "Jl. Kenanga No. 9",
        "telepon": "0814-3333-4444",
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
            /// Tombol Navigasi Responsif
            LayoutBuilder(
              builder: (context, constraints) {
                final addButton = ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/warga/tambah');
                  },
                  icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                  label: const Text("Tambah Warga"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );

                final refreshButton = ElevatedButton.icon(
                  onPressed: () {
                    // TODO: logika refresh data warga
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text("Refresh"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );

                if (constraints.maxWidth > 600) {
                  // layar besar → tombol sejajar kanan atas
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      addButton,
                      const SizedBox(width: 12),
                      refreshButton,
                    ],
                  );
                } else {
                  // layar kecil → tombol ditumpuk
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      addButton,
                      const SizedBox(height: 8),
                      refreshButton,
                    ],
                  );
                }
              },
            ),

            const SizedBox(height: 16),

            /// Tabel Data Responsif
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
                          dataRowColor:
                              WidgetStateProperty.all(Colors.white),
                          columns: const [
                            DataColumn(
                              label: Text(
                                "No",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryBlue),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Nama Warga",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryBlue),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Alamat",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryBlue),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "No Telepon",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryBlue),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                "Aksi",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primaryBlue),
                              ),
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
                                  IconButton(
                                    icon: const Icon(Icons.more_vert,
                                        color: AppTheme.primaryBlue),
                                    onPressed: () {
                                      // TODO: tampilkan opsi detail/edit/hapus
                                      debugPrint(
                                          "Klik aksi untuk ${row["nama"]}");
                                    },
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
}
