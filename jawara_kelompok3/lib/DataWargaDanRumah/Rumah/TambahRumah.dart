import 'package:flutter/material.dart';
import '../../layout/sidebar.dart';
import '../../theme/app_theme.dart'; // ✅ gunakan AppTheme

class TambahRumahPage extends StatelessWidget {
  const TambahRumahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        title: const Text(
          "Daftar Warga",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                AppTheme.primaryBlue.withOpacity(0.1),
              ),
              columns: const [
                DataColumn(
                  label: Text(
                    "No",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Nama Warga",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Alamat",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "No Telepon",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "Aksi",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
              ],
              rows: List.generate(
                10,
                (index) => DataRow(
                  cells: [
                    DataCell(Text((index + 1).toString())),
                    DataCell(Text("Warga ${index + 1}")),
                    const DataCell(Text("Jl. Contoh No. 123")),
                    const DataCell(Text("0812-3456-7890")),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: AppTheme.backgroundBlueWhite, // ✅ warna dasar dari AppTheme
    );
  }
}
