import 'package:flutter/material.dart';

class PengeluaranCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit;

  const PengeluaranCard({
    super.key,
    required this.data,
    this.onDetail,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final nama = data['nama']?.toString() ?? '-';
    final jenis = data['jenis']?.toString() ?? '-';
    final tanggal = data['tanggal']?.toString() ?? '-';
    final nominal = data['nominal']?.toString() ?? '-';

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
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon kiri
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.money_off, color: Colors.red),
          ),

          const SizedBox(width: 16),

          // Teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
                const SizedBox(height: 4),
                Text("Jenis: $jenis",
                    style:
                        TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                Text("Tanggal: $tanggal",
                    style:
                        TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                Text("Nominal: $nominal",
                    style:
                        TextStyle(color: Colors.grey.shade700, fontSize: 13)),
              ],
            ),
          ),

          // Popup menu
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'detail' && onDetail != null) onDetail!();
              if (value == 'edit' && onEdit != null) onEdit!();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'detail',
                child: Row(
                  children: [
                    Icon(Icons.visibility, color: Colors.blue),
                    SizedBox(width: 8),
                    Text("Lihat Detail"),
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