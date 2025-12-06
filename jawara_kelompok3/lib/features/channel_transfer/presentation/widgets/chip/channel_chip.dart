import 'package:flutter/material.dart';

class ChannelTransferChip extends StatelessWidget {
  final String jenis;

  const ChannelTransferChip({super.key, required this.jenis});

  Color _bgColor(String type) {
    switch (type.toLowerCase()) {
      case "manual":
        return Colors.orange.shade50;
      case "otomatis":
        return Colors.green.shade50;
      case "qr":
        return Colors.blue.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _textColor(String type) {
    switch (type.toLowerCase()) {
      case "manual":
        return Colors.orange.shade800;
      case "otomatis":
        return Colors.green.shade800;
      case "qr":
        return Colors.blue.shade800;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _bgColor(jenis);
    final color = _textColor(jenis);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        jenis.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
