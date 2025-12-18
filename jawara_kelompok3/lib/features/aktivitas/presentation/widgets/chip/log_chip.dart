import 'package:flutter/material.dart';

class LogChip extends StatelessWidget {
  final String status;

  const LogChip({super.key, required this.status});

  Color _bgColor(String status) {
    switch (status.toLowerCase()) {
      case "sukses":
        return Colors.green.shade50;
      case "gagal":
        return Colors.red.shade50;
      case "proses":
        return Colors.orange.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _textColor(String status) {
    switch (status.toLowerCase()) {
      case "sukses":
        return Colors.green.shade800;
      case "gagal":
        return Colors.red.shade800;
      case "proses":
        return Colors.orange.shade800;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _bgColor(status);
    final color = _textColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
