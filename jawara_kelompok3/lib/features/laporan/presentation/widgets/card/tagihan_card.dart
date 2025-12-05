import 'package:flutter/material.dart';
import '../../../data/models/tagihan_model.dart';

class TagihanCard extends StatelessWidget {
  final TagihanModel data;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete; // Tambahkan onDelete

  const TagihanCard({
    super.key,
    required this.data,
    this.onDetail,
    this.onEdit,
    this.onDelete, // Pastikan onDelete tersedia
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.receipt_long, color: Colors.blue),
          ),

          const SizedBox(width: 16),

          // Text Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.keluarga,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text("Iuran: ${data.iuran}",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                Text("Periode: ${data.periode}",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                Text("Nominal: ${data.nominal}",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                Text("Status: ${data.tagihanStatus}",
                    style: TextStyle(
                        color: data.tagihanStatus == "Belum Dibayar"
                            ? Colors.red
                            : Colors.green,
                        fontSize: 13)),
              ],
            ),
          ),

          // Popup Menu
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'detail' && onDetail != null) onDetail!();
              if (value == 'edit' && onEdit != null) onEdit!();
              if (value == 'delete' && onDelete != null) onDelete!(); // Trigger delete if selected
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'detail',
                child: Row(
                  children: [
                    Icon(Icons.visibility, color: Colors.blue),
                    SizedBox(width: 8),
                    Text("Detail"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.orange),
                    SizedBox(width: 8),
                    Text("Edit"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete', 
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text("Hapus"),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
