import 'package:flutter/material.dart';
import '../../../data/models/pengguna_model.dart';
import '../../../../../core/theme/app_theme.dart';

class PenggunaCard extends StatelessWidget {
  final User data;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PenggunaCard({
    super.key,
    required this.data,
    this.onDetail,
    this.onEdit,
    this.onDelete,
  });

  // Helper warna status
  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aktif':
        return Colors.green.shade600;
      case 'nonaktif':
        return Colors.red.shade600;
      case 'pindah':
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fallback untuk email dan role jika kosong
    final email = (data.email.isNotEmpty) ? data.email : '-';
    final role = (data.role.isNotEmpty) ? data.role : '-';
    final rawStatus = (data.statusWarga.isEmpty ? "aktif" : data.statusWarga);

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon pengguna
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
                child: const Icon(Icons.account_circle,
                    color: Colors.blue, size: 28),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Data pengguna (vertikal)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama
                Text(
                  data.nama,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Field data vertikal dengan label
                Text("Email: $email",
                    style: TextStyle(color: Colors.grey.shade700)),
                Text("No HP: ${data.noHp.isEmpty ? '-' : data.noHp}",
                    style: TextStyle(color: Colors.grey.shade700)),
                Text("NIK: ${data.nik}",
                    style: TextStyle(color: Colors.grey.shade700)),
                Text("Role: $role",
                    style: TextStyle(color: Colors.grey.shade700)),
                Text("Jenis Kelamin: ${data.jenisKelamin}",
                    style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 12),

                // Status + createdAt
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
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
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Popup menu
          PopupMenuButton(
            onSelected: (value) {
              if (value == "detail" && onDetail != null) onDetail!();
              if (value == "edit" && onEdit != null) onEdit!();
              if (value == "hapus" && onDelete != null) onDelete!();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: "detail",
                child: Row(
                  children: [
                    Icon(Icons.visibility, color: Colors.blue),
                    SizedBox(width: 8),
                    Text("Detail"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "edit",
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.orange),
                    SizedBox(width: 8),
                    Text("Edit"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "hapus",
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
