import 'package:flutter/material.dart';

class KeluargaStatusChip extends StatelessWidget {
  final String status;

  const KeluargaStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final st = status.toLowerCase();

    late Color bg;
    late Color border;
    late Color text;

    // === Warna mengikuti konsep RumahStatusChip ===
    if (st == "aktif") {
      bg = Colors.green.shade50;
      border = Colors.green;
      text = Colors.green.shade700;
    } else if (st == "pindah") {
      bg = Colors.orange.shade50;
      border = Colors.orange;
      text = Colors.orange.shade700;
    } else if (st == "sementara") {
      bg = Colors.blue.shade50;
      border = Colors.blue;
      text = Colors.blue.shade700;
    } else {
      bg = Colors.grey.shade200;
      border = Colors.grey;
      text = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 0.8),
      ),
      child: Text(
        st[0].toUpperCase() + st.substring(1), // Kapitalisasi otomatis
        style: TextStyle(
          color: text,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
