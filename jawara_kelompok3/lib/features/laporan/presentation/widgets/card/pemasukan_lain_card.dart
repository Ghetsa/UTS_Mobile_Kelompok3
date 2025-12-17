import 'package:flutter/material.dart';
import '../../../data/models/pemasukan_lain_model.dart';

class PemasukanCard extends StatelessWidget {
  final PemasukanLainModel data;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PemasukanCard({
    super.key,
    required this.data,
    this.onDetail,
    this.onEdit,
    this.onDelete,
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
              offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.attach_money, color: Colors.green),
          ),
          const SizedBox(width: 16),
          // Teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.nama,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17)),
                const SizedBox(height: 4),
                Text("Jenis: ${data.jenis}",
                    style:
                        TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                Text("Tanggal: ${data.tanggal}",
                    style:
                        TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                Text("Nominal: ${data.nominal}",
                    style:
                        TextStyle(color: Colors.grey.shade700, fontSize: 13)),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'detail' && onDetail != null) onDetail!();
              if (value == 'delete' && onDelete != null) onDelete!();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: 'detail',
                  child: Row(children: [
                    Icon(Icons.visibility, color: Colors.blue),
                    SizedBox(width: 8),
                    Text("Lihat Detail")
                  ])),
              const PopupMenuItem(
                  value: 'delete',
                  child: Row(children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text("Hapus")
                  ])), // Added delete option
            ],
          ),
        ],
      ),
    );
  }
}
