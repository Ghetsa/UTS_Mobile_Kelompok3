import 'package:flutter/material.dart';
import '../../../data/models/pengguna_model.dart';

class PenggunaCard extends StatelessWidget {
  final User data;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PenggunaCard({
    super.key,
    required this.data,
    this.onDetail,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        title: Text(
          data.nama,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${data.email} - ${data.noHp}"),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == "detail" && onDetail != null) onDetail!();
            if (value == "edit" && onEdit != null) onEdit!();
            if (value == "hapus" && onDelete != null) onDelete!();
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: "detail",
              child: Row(
                children: [
                  Icon(Icons.visibility, color: Colors.blue),
                  SizedBox(width: 8),
                  Text("Detail"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: "edit",
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.orange),
                  SizedBox(width: 8),
                  Text("Edit"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: "hapus",
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text("Hapus"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
