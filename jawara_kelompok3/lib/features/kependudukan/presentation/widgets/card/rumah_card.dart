import 'package:flutter/material.dart';
import '../../../data/models/rumah_model.dart';

// 🔹 import keluarga service
import '../../../data/services/keluarga_service.dart';
import '../../../data/models/keluarga_model.dart';

class RumahCard extends StatelessWidget {
  final RumahModel data;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const RumahCard({
    super.key,
    required this.data,
    this.onDetail,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor() {
      switch (data.statusRumah.toLowerCase()) {
        case 'dihuni':
          return Colors.green.shade600;
        case 'kosong':
          return Colors.orange.shade600;
        case 'renovasi':
          return Colors.blueGrey.shade600;
        default:
          return Colors.grey.shade700;
      }
    }

    final keluargaService = KeluargaService();

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

                Text(
                  "No Rumah: ${data.nomor} • RT/RW: ${data.rt}/${data.rw}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 4),

                // 🔹 Penghuni: ambil keluarga dengan id_rumah == data.docId
                FutureBuilder<KeluargaModel?>(
                  future:
                      keluargaService.getKeluargaByRumahId(data.docId),
                  builder: (context, snapshot) {
                    String text = "Penghuni: -";

                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      text = "Penghuni: (memuat...)";
                    } else if (snapshot.hasError) {
                      text = "Penghuni: -";
                    } else if (snapshot.hasData && snapshot.data != null) {
                      text = "Penghuni: ${snapshot.data!.kepalaKeluarga}";
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

                Text(
                  "Kepemilikan: ${data.kepemilikan}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 6),

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
                            data.statusRumah,
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

          PopupMenuButton(
            onSelected: (v) {
              if (v == 'detail' && onDetail != null) onDetail!();
              if (v == 'edit' && onEdit != null) onEdit!();
              if (v == 'hapus' && onDelete != null) onDelete!();
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
