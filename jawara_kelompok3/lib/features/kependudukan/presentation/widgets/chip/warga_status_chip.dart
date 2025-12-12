import 'package:flutter/material.dart';

class WargaStatusChip extends StatelessWidget {
  final String status;

  const WargaStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isActive = status.toLowerCase() == "aktif";
    final bg = isActive ? Colors.green.shade50 : Colors.red.shade50;
    final color = isActive ? Colors.green.shade800 : Colors.red.shade800;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }
}
