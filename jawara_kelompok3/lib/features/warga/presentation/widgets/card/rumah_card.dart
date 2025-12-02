import 'package:flutter/material.dart';
import '../../../data/models/rumah_model.dart';
import '../../../data/services/rumah_service.dart';

class RumahCard extends StatelessWidget {
  final RumahModel data;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete; // 👈 callback hapus

  const RumahCard({
    super.key,
    required this.data,
    this.onDetail,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Warna kecil buat badge/status
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
                // Alamat
                Text(
                  data.alamat,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // No rumah + RT/RW
                Text(
                  "No Rumah: ${data.nomor} • RT/RW: ${data.rt}/${data.rw}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 4),

                // Penghuni (ambil dari id keluarga)
                if (data.penghuniKeluargaId.isEmpty)
                  Text(
                    "Penghuni: -",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  )
                else
                  FutureBuilder<String?>(
                    future: RumahService()
                        .getNamaKepalaKeluarga(data.penghuniKeluargaId),
                    builder: (context, snapshot) {
                      String text;

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        text =
                            "Penghuni: (memuat...) [ID: ${data.penghuniKeluargaId}]";
                      } else if (snapshot.hasError) {
                        text =
                            "Penghuni: (gagal muat) [ID: ${data.penghuniKeluargaId}]";
                      } else {
                        final nama = snapshot.data;
                        if (nama == null || nama.isEmpty) {
                          text = "Penghuni: [ID: ${data.penghuniKeluargaId}]";
                        } else {
                          text =
                              "Penghuni: $nama [ID: ${data.penghuniKeluargaId}]";
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

                // Kepemilikan
                Text(
                  "Kepemilikan: ${data.kepemilikan}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 6),

                // Status badge + created time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Status badge
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

                    // CreatedAt
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

          // MENU (detail, edit, hapus)
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
