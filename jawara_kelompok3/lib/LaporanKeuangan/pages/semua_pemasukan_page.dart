import 'package:flutter/material.dart';
import '../../layout/sidebar.dart';
import '../../theme/app_theme.dart';
import '../widgets/filter_form.dart'; 

class SemuaPemasukanPage extends StatelessWidget {
  const SemuaPemasukanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data = [
      {
        "no": 1,
        "nama": "Joki by Firman",
        "jenis": "Pendapatan Lainnya",
        "tanggal": "13 Okt 2025 00:55",
        "nominal": "Rp 49.999.997,00",
      },
      {
        "no": 2,
        "nama": "Tes",
        "jenis": "Pendapatan Lainnya",
        "tanggal": "12 Agt 2025 13:26",
        "nominal": "Rp 10.000,00",
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Semua Pemasukan")),
      drawer: const AppSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 600;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Tombol Filter
                Align(
                  alignment: isWide ? Alignment.centerRight : Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => const FilterFormDialog(title: "Filter Pemasukan"),
                      );
                    },
                    icon: const Icon(Icons.filter_alt),
                    label: const Text("Filter"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ✅ Tabel Data
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor:
                          MaterialStateProperty.all(Colors.grey[200]),
                      columns: const [
                        DataColumn(label: Text("No")),
                        DataColumn(label: Text("Nama")),
                        DataColumn(label: Text("Jenis Pemasukan")),
                        DataColumn(label: Text("Tanggal")),
                        DataColumn(label: Text("Nominal")),
                        DataColumn(label: Text("Aksi")),
                      ],
                      rows: data.map((row) {
                        return DataRow(
                          cells: [
                            DataCell(Text(row["no"].toString())),
                            DataCell(Text(row["nama"])),
                            DataCell(Text(row["jenis"])),
                            DataCell(Text(row["tanggal"])),
                            DataCell(Text(row["nominal"])),
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
