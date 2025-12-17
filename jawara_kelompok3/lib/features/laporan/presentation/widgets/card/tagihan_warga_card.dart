import 'package:flutter/material.dart';
import '../../../data/models/tagihan_warga_model.dart';

class TagihanCardWarga extends StatelessWidget {
  final TagihanWargaModel data;
  final VoidCallback? onDetail;
  final VoidCallback? onEdit; // This is used for "Bayar Tagihan"

  const TagihanCardWarga({
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
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.receipt_long, color: Colors.blue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.keluarga,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  "Iuran: ${data.iuran}",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
                Text(
                  "Periode: ${data.periode}",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
                Text(
                  "Nominal: Rp ${data.nominal}",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: data.tagihanStatus == "Belum Dibayar"
                        ? Colors.red.shade50
                        : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data.tagihanStatus,
                    style: TextStyle(
                      color: data.tagihanStatus == "Belum Dibayar"
                          ? Colors.red.shade700
                          : Colors.green.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'detail' && onDetail != null) onDetail!();
              if (value == 'bayar' && onEdit != null) onEdit!(); 
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'detail',
                child: Row(
                  children: [
                    Icon(Icons.visibility, color: Colors.blue),
                    SizedBox(width: 8),
                    Text("Detail"),
                  ],
                ),
              ),
              // Only show "Bayar Tagihan" if status is "Belum Dibayar"
              if (data.tagihanStatus == "Belum Dibayar")
                const PopupMenuItem(
                  value: 'bayar', 
                  child: Row(
                    children: [
                      Icon(Icons.payment, color: Colors.green),
                      SizedBox(width: 8),
                      Text("Bayar Tagihan"),
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