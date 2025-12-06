import 'package:flutter/material.dart';
import '../../../data/models/keluarga_model.dart';
import '../../../data/services/rumah_service.dart';

class KeluargaCard extends StatelessWidget {
  final KeluargaModel data;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const KeluargaCard({
    super.key,
    required this.data,
    this.onDetail,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final rawStatus =
        (data.statusKeluarga.isEmpty ? "aktif" : data.statusKeluarga)
            .toLowerCase();

    Color statusColor() {
      switch (rawStatus) {
        case 'aktif':
          return Colors.green.shade600;
        case 'pindah':
          return Colors.orange.shade600;
        case 'sementara':
          return Colors.blueGrey.shade600;
        default:
          return Colors.grey.shade700;
      }
    }

    String statusText() {
      if (rawStatus.isEmpty) return "-";
      return rawStatus[0].toUpperCase() + rawStatus.substring(1);
    }

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
          // ICON KELUARGA
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.family_restroom, color: Colors.blue),
          ),

          const SizedBox(width: 16),

          // INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kepala keluarga (pakai label seperti di form)
                Text(
                  "Kepala Keluarga: ${data.kepalaKeluarga}",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // No KK + Jumlah anggota
                Text(
                  "No KK: ${data.noKk} • Anggota: ${data.jumlahAnggota}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 4),

                // Info rumah (alamat, bukan docId)
                if (data.idRumah.isEmpty)
                  Text(
                    "Rumah: -",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  )
                else
                  FutureBuilder<String?>(
                    future: RumahService().getAlamatRumahByDocId(data.idRumah),
                    builder: (context, snapshot) {
                      String text;

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        text = "Rumah: (memuat...)";
                      } else if (snapshot.hasError) {
                        text = "Rumah: -";
                      } else {
                        final alamat = snapshot.data;
                        if (alamat == null || alamat.isEmpty) {
                          text = "Rumah: -";
                        } else {
                          text = "Rumah: $alamat";
                        }
                      }

                      return Text(
                        text,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 6),

                // Status badge + createdAt
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 8, color: statusColor()),
                          const SizedBox(width: 6),
                          Text(
                            statusText(),
                            style: TextStyle(
                              fontSize: 12,
                              color: statusColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      data.createdAt != null
                          ? data.createdAt.toString().substring(0, 16)
                          : "-",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // MENU
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
