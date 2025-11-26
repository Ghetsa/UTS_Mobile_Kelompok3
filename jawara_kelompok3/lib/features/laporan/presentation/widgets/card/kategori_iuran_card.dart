import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../dialog/detail_kategori_dialog.dart';
import '../dialog/edit_kategori_dialog.dart';

class KategoriIuranCard extends StatelessWidget {
  final Map<String, String> row;

  const KategoriIuranCard({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.category, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    row["nama"]!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: AppTheme.primaryBlue),
                  onSelected: (value) async {
                    if (value == 'detail') {
                      await showDialog(
                        context: context,
                        builder: (context) =>
                            DetailKategoriDialog(kategori: row),
                      );
                    } else if (value == 'edit') {
                      await showDialog<Map<String, String>>(
                        context: context,
                        builder: (context) =>
                            EditIuranDialog(iuran: row),
                      );
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'detail',
                      child: Row(children: [
                        Icon(Icons.visibility, color: Colors.blue),
                        SizedBox(width: 8),
                        Text("Detail"),
                      ]),
                    ),
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(children: [
                        Icon(Icons.edit, color: Colors.orange),
                        SizedBox(width: 8),
                        Text("Edit"),
                      ]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            _info("Jenis Iuran", row["jenis"]!),
            _info("Nominal", "Rp ${row["nominal"]},00"),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: "$label: ", style: const TextStyle(fontWeight: FontWeight.w600)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
