import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/mutasi_model.dart';

class MutasiCard extends StatelessWidget {
  final MutasiModel data;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MutasiCard({
    super.key,
    required this.data,
    this.onDetail,
    this.onEdit,
    this.onDelete,
  });

  Future<String> _getNamaWarga(String idWarga) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('warga')
          .doc(idWarga)
          .get();

      if (doc.exists) {
        return doc.data()?['nama'] ?? "Tidak diketahui";
      }
      return "Tidak ditemukan";
    } catch (e) {
      return "Gagal memuat";
    }
  }

  Color _jenisColor() {
    final j = data.jenisMutasi.toLowerCase();
    if (j.contains('keluar')) return Colors.red.shade600;
    if (j.contains('masuk')) return Colors.green.shade600;
    if (j.contains('sementara')) return Colors.blue.shade600;
    return Colors.grey.shade700;
  }

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
            color: Colors.black12.withOpacity(.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          )
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
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.sync_alt, color: Colors.blue),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // JUDUL
                Text(
                  data.jenisMutasi.isEmpty
                      ? "Mutasi"
                      : data.jenisMutasi.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 6),

                // 🔥 NAMA WARGA (AUTO FETCH)
                FutureBuilder<String>(
                  future: _getNamaWarga(data.idWarga),
                  builder: (context, snapshot) {
                    final nama = snapshot.data ?? "Memuat...";
                    return Text(
                      "Warga: $nama",
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 6),

                // KETERANGAN
                Text(
                  "Keterangan: ${data.keterangan.isEmpty ? '-' : data.keterangan}",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // CHIP + TANGGAL
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // CHIP
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _jenisColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 8, color: _jenisColor()),
                          const SizedBox(width: 6),
                          Text(
                            data.jenisMutasi,
                            style: TextStyle(
                              fontSize: 12,
                              color: _jenisColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      data.createdAt?.toString().substring(0, 16) ?? "-",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // POPUP MENU
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'detail') onDetail?.call();
              if (value == 'edit') onEdit?.call();
              if (value == 'hapus') onDelete?.call();
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
