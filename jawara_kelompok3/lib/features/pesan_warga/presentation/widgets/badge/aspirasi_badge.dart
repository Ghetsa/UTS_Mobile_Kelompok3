import 'package:flutter/material.dart';

class AspirasiBadge extends StatelessWidget {
  final String label;
  const AspirasiBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color textColor;

    switch (label.toLowerCase()) {
      case "selesai":
        bg = Colors.green.shade50;
        textColor = Colors.green.shade800;
        break;
      case "proses":
        bg = Colors.orange.shade50;
        textColor = Colors.orange.shade800;
        break;
      case "ditolak":
        bg = Colors.red.shade50;
        textColor = Colors.red.shade800;
        break;
      default:
        bg = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Text(
        label, // tampil persis, tanpa diubah uppercase/lowercase
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
