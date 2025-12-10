import 'package:flutter/material.dart';

class AspirasiChip extends StatelessWidget {
  final String status;
  const AspirasiChip({super.key, required this.status});

  Color _bgColor(String status) {
    switch (status.toLowerCase()) {
      case "selesai":
        return Colors.green.shade50;
      case "proses":
        return Colors.orange.shade50;
      case "ditolak":
        return Colors.red.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _textColor(String status) {
    switch (status.toLowerCase()) {
      case "selesai":
        return Colors.green.shade800;
      case "proses":
        return Colors.orange.shade800;
      case "ditolak":
        return Colors.red.shade800;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _bgColor(status);
    final color = _textColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), // persis sama
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20), // persis sama
        border: Border.all(color: color.withOpacity(0.3)), // persis sama
      ),
      child: Text(
        status, // tampil persis, tanpa diubah uppercase
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12, // sama persis
        ),
      ),
    );
  }
}
