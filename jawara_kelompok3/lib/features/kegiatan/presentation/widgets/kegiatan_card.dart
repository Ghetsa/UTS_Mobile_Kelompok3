import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/models/kegiatan_model.dart';

class KegiatanCard extends StatelessWidget {
  final KegiatanModel data;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const KegiatanCard({
    super.key,
    required this.data,
    this.onDetail,
    this.onEdit,
    this.onDelete,
  });

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s == 'berjalan') return Colors.blue;
    if (s == 'selesai') return Colors.green;
    if (s == 'batal') return Colors.red;
    return Colors.orange; // rencana
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '-';
    return "${d.day.toString().padLeft(2, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(data.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // icon
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppTheme.blueMediumLight.withOpacity(.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.event, color: AppTheme.blueDark),
          ),
          const SizedBox(width: 16),

          // info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.nama,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${data.kategori} • ${data.lokasi}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "PJ: ${data.penanggungJawab}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Mulai: ${_formatDate(data.tanggalMulai)}"
                  "${data.tanggalSelesai != null ? "  •  Selesai: ${_formatDate(data.tanggalSelesai)}" : ""}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(.12),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle,
                              size: 8, color: statusColor),
                          const SizedBox(width: 6),
                          Text(
                            data.status[0].toUpperCase() +
                                data.status.substring(1),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      data.createdAt != null
                          ? _formatDate(data.createdAt)
                          : "-",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

          PopupMenuButton(
            onSelected: (value) {
              if (value == 'detail' && onDetail != null) onDetail!();
              if (value == 'edit' && onEdit != null) onEdit!();
              if (value == 'hapus' && onDelete != null) onDelete!();
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
                value: 'hapus',
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
        ],
      ),
    );
  }
}
