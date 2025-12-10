import 'package:flutter/material.dart';
import '../../../data/models/pesan_warga_model.dart';
import '../../../../../core/theme/app_theme.dart';

class AspirasiCard extends StatelessWidget {
  final PesanWargaModel data;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AspirasiCard({
    super.key,
    required this.data,
    this.onDetail,
    this.onEdit,
    this.onDelete,
  });

  // Helper warna status
  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return Colors.green.shade600;
      case 'proses':
        return Colors.orange.shade600;
      case 'ditolak':
        return Colors.red.shade600;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rawStatus = (data.status.isEmpty ? "proses" : data.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Icon Aspirasi
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade100.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.message, color: Colors.blue, size: 28),
            ),
          ],
        ),
        const SizedBox(width: 16),

        // Data Aspirasi (vertikal)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Warga
              Text(
                data.nama,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 4),

              // Isi Pesan
              Text(
                data.isiPesan,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // ID Pesan
              Text("ID: ${data.idPesan}",
                  style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 12),

              // Status + CreatedAt
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Status badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor(rawStatus).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle,
                            size: 10, color: statusColor(rawStatus)),
                        const SizedBox(width: 6),
                        Text(
                          rawStatus[0].toUpperCase() + rawStatus.substring(1),
                          style: TextStyle(
                            fontSize: 13,
                            color: statusColor(rawStatus),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // CreatedAt
                  Text(
                    data.createdAt != null
                        ? data.createdAt.toString().substring(0, 16)
                        : "-",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Popup menu
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case "detail":
                if (onDetail != null) onDetail!();
                break;
              case "edit":
                if (onEdit != null) onEdit!();
                break;
              case "hapus":
                if (onDelete != null)
                  onDelete!(); // ini akan panggil dialog konfirmasi di parent
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: "detail",
              child: Row(
                children: const [
                  Icon(Icons.visibility, color: Colors.blue),
                  SizedBox(width: 8),
                  Text("Detail"),
                ],
              ),
            ),
            PopupMenuItem(
              value: "edit",
              child: Row(
                children: const [
                  Icon(Icons.edit, color: Colors.orange),
                  SizedBox(width: 8),
                  Text("Edit"),
                ],
              ),
            ),
            PopupMenuItem(
              value: "hapus",
              child: Row(
                children: const [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text("Hapus"),
                ],
              ),
            ),
          ],
        )
      ]),
    );
  }
}
