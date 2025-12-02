import 'package:flutter/material.dart';
import '../../../data/models/mutasi_model.dart';

class MutasiCard extends StatelessWidget {
  final MutasiModel data;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit;

  const MutasiCard({
    super.key,
    required this.data,
    this.onDetail,
    this.onEdit,
  });

  String _formatDate(DateTime? dt) {
    if (dt == null) return "-";
    return "${dt.day.toString().padLeft(2, '0')}-"
        "${dt.month.toString().padLeft(2, '0')}-"
        "${dt.year}";
  }

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
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ICON KIRI
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.sync_alt, color: Colors.blue),
          ),

          const SizedBox(width: 16),

          /// TEXT INFORMASI
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Jenis Mutasi
                Text(
                  data.jenisMutasi.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "ID Warga: ${data.idWarga}",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "Keterangan: ${data.keterangan}",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                Text(
                  "Doc ID: ${data.uid}",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 6),

                /// TANGGAL MUTASI
                Text(
                  "Tanggal mutasi: ${_formatDate(data.tanggal)}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),

                /// OPSIONAL: kalau mau tampilkan createdAt juga
                if (data.createdAt != null)
                  Text(
                    "Dibuat: ${_formatDate(data.createdAt)}",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade400,
                    ),
                  ),
              ],
            ),
          ),

          /// POPUP MENU
          PopupMenuButton(
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
          )
        ],
      ),
    );
  }
}
