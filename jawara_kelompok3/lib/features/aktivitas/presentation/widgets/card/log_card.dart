import 'package:flutter/material.dart';
import '../../../data/models/aktivitas_model.dart';
import '../badge/log_badge.dart';

class LogCard extends StatelessWidget {
  final Log data;
  final VoidCallback? onDetail;

  const LogCard({super.key, required this.data, this.onDetail});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.orange.shade100.withOpacity(0.4), blurRadius: 6, offset: const Offset(0, 3))],
            ),
            child: const Icon(Icons.list_alt, color: Colors.orange, size: 28),
          ),
          const SizedBox(width: 16),

          // Data log
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.aktivitas, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Text("Aktor: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    LogBadge(role: data.role),
                  ],
                ),
                const SizedBox(height: 6),
                Text("Tanggal & Jam: ${data.tanggal.toString().substring(0, 16)}", style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),
          ),

          // Detail button
          IconButton(
            onPressed: onDetail,
            icon: const Icon(Icons.visibility, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
