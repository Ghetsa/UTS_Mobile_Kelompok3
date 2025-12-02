import 'package:flutter/material.dart';
import '../../../data/models/keluarga_model.dart';

class KeluargaCard extends StatelessWidget {
  final KeluargaModel data;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit;

  const KeluargaCard({
    super.key,
    required this.data,
    this.onDetail,
    this.onEdit,
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
            child: const Icon(Icons.family_restroom, color: Colors.blue),
          ),

          const SizedBox(width: 16),

          /// TEXT INFORMASI
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Kepala Keluarga (judul utama)
                Text(
                  data.kepalaKeluarga,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 4),

                /// No KK
                Text(
                  "No. KK: ${data.noKk}",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),

                /// Jumlah anggota
                Text(
                  "Jumlah Anggota: ${data.jumlahAnggota}",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),

                /// ID Rumah (docId rumah yang dikaitkan)
                Text(
                  "ID Rumah: ${data.idRumah}",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 6),

                /// Created at
                Text(
                  data.createdAt != null
                      ? data.createdAt.toString().substring(0, 16)
                      : '-',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),

          /// MENU POPUP
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
