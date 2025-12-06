import 'package:flutter/material.dart';

class PenggunaChip extends StatelessWidget {
  final String status;

  const PenggunaChip({super.key, required this.status});

  Color _bgColor(String status) {
    switch (status.toLowerCase()) {
      case "diterima":
        return Colors.green.shade50;
      case "menunggu persetujuan":
        return Colors.orange.shade50;
      case "ditolak":
        return Colors.red.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _textColor(String status) {
    switch (status.toLowerCase()) {
      case "diterima":
        return Colors.green.shade800;
      case "menunggu persetujuan":
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), // sama persis
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20), // sama persis
        border: Border.all(color: color.withOpacity(0.3)), // sama persis
      ),
      child: Text(
        status, // **tidak diubah ke UPPERCASE** agar persis dengan ChannelTransferChip
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12, // tambahkan agar sama persis dengan font ChannelTransferChip
        ),
      ),
    );
  }
}
