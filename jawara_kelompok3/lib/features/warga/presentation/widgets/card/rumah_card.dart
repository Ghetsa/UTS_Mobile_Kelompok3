import 'package:flutter/material.dart';
import '../../../data/models/rumah_model.dart';

class RumahCard extends StatelessWidget {
  final RumahModel data;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit;

  const RumahCard({
    super.key,
    required this.data,
    this.onDetail,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ICON
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.home, color: Colors.green),
          ),

          const SizedBox(width: 16),

          // INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.alamat,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),
                Text("Penghuni: ${data.penghuni}"),
                Text("Status: ${data.status}"),
                Text("Kepemilikan: ${data.kepemilikan}"),

                const SizedBox(height: 6),
                Text(
                  data.createdAt != null
                      ? data.createdAt.toString().substring(0, 16)
                      : "-",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          // MENU
          PopupMenuButton(
            onSelected: (v) {
              if (v == 'detail' && onDetail != null) onDetail!();
              if (v == 'edit' && onEdit != null) onEdit!();
            },
            itemBuilder: (_) => const [
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
            ],
          ),
        ],
      ),
    );
  }
}
