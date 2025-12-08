import 'package:flutter/material.dart';
import '../../../data/models/channel_transfer_model.dart';
import '../badge/channel_badge.dart';

class ChannelTransferCard extends StatelessWidget {
  final ChannelTransfer data;
  final int index; // nomor urut
  final VoidCallback? onDetail;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ChannelTransferCard({
    super.key,
    required this.data,
    required this.index,
    this.onDetail,
    this.onEdit,
    this.onDelete,
  });

  // Helper warna badge
  Color badgeColor(String type) {
    switch (type.toLowerCase()) {
      case 'manual':
        return Colors.orange.shade600;
      case 'auto':
        return Colors.green.shade600;
      case 'qr':
        return Colors.blue.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          // Nomor urut + Icon
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFF48B0E0),
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
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
                child: Icon(
                  data.jenis.toLowerCase() == 'manual'
                      ? Icons.handshake
                      : data.jenis.toLowerCase() == 'auto'
                          ? Icons.autorenew
                          : Icons.qr_code,
                  color: Colors.blue,
                  size: 28,
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Data channel vertikal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.namaChannel,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("Rekening: ${data.nomorRekening}",
                    style: TextStyle(color: Colors.grey.shade700)),
                Text("Bank: ${data.kodeBank}",
                    style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 12),
                // Badge jenis channel
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: badgeColor(data.jenis).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle,
                              size: 10, color: badgeColor(data.jenis)),
                          const SizedBox(width: 6),
                          Text(
                            data.jenis[0].toUpperCase() +
                                data.jenis.substring(1),
                            style: TextStyle(
                                fontSize: 13,
                                color: badgeColor(data.jenis),
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
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
